//
//  APIManager.swift
//  iDic
//
//  Created by Yura Granchenko on 10/18/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import Foundation
import RxCocoa
import Alamofire
import RxSwift
import RxAlamofire
import SwiftyJSON

let timeOutInterval = 120.0
let SERVER_URL = "https://idic.herokuapp.com/api/"

enum APIManager: URLRequestConvertible {
    
    case voucherInfo
    case login
    case genericToU
    case domicileToU
    case file
    case domicileList
    case leadRestrictions
    case checkTrialAccess
    case trialVoucher([String: Any])
    case sendEmail([String: Any])
    case signup([String: Any])
    
    func asURLRequest() throws -> URLRequest {
        
        var disposeBag = DisposeBag()
        let headers: [String: String] = {
            switch self {
            default:
                return [:]
            }
        }()
        
        var method: HTTPMethod {
            switch self {
            case .genericToU, .domicileToU, .voucherInfo, .login, .file, .domicileList, .leadRestrictions, .checkTrialAccess, .trialVoucher:
                return .get
            case .signup:
                return .post
            case .sendEmail:
                return .put
            }
        }
        
        let parameters: ([String: Any]?) = {
            switch self {
            case .sendEmail(let parameters), .trialVoucher(let parameters), .signup(let parameters):
                return parameters
            default: return nil
            }
        }()
        
        let url: URL = {
            let query: String?
            switch self {
            case .signup:
                query = "auth/register"
            case .voucherInfo:
                query = "VoucherInfo"
            case .login:
                query = "Login"
            case .genericToU:
                query = "GenericTermOfUse"
            case .domicileToU:
                query = "DomicileTermOfUse"
            case .file:
                query = "File/10432"
            case .sendEmail:
                query = "SendEmail"
            case .domicileList:
                query = "DomicileList"
            case .leadRestrictions:
                query = "LeadRestrictions"
            case .checkTrialAccess:
                query = "CheckTrialAccess"
            case .trialVoucher:
                query = "TrialVoucher"
            }
            
            var URL = Foundation.URL(string: SERVER_URL)!
            if let query = query {
                URL = URL.appendingPathComponent(query)
            }
            return URL
        }()
        
        Logger.log("REQUEST for \n\t url - \(url)\n\t method - \(method)\n\t parameters - \(parameters ?? [:])", color: .orange)
        #if DEBUG
            Logger.log("header - \n\t\(headers)", color: .orange)
        #endif
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = timeOutInterval
        
        for (headerField, headerValue) in headers {
            urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
        
        switch self {
        case .sendEmail:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
    
    func json(_ file: Any = #file, function: Any = #function, line: Int = #line) -> RxSwift.Observable<JSON> {
        return RxAlamofire.request(self)
            .responseJSON()
            .shareReplay(1)
            .flatMapLatest { response -> RxSwift.Observable<JSON> in
                var errorDescription = ""
                var errorReason = ""
                if case let .failure(error) = response.result {
                    if let error = error as? AFError {
                        switch error {
                        case .invalidURL(let url):
                            errorReason = "Invalid URL: " + "\(url) - \(error.localizedDescription)"
                        case .parameterEncodingFailed(let reason):
                            errorDescription = "Parameter encoding failed: " + "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                        case .multipartEncodingFailed(let reason):
                            errorDescription = "Multipart encoding failed: " + "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                        case .responseValidationFailed(let reason):
                            errorDescription = "Response validation failed: " + "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                            
                            switch reason {
                            case .dataFileNil, .dataFileReadFailed:
                                errorDescription = "Downloaded file could not be read"
                            case .missingContentType(let acceptableContentTypes):
                                errorDescription = "Content Type Missing: " + "\(acceptableContentTypes)"
                            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                                errorDescription = "Response content type: " + "\(responseContentType) " + "was unacceptable: " + "\(acceptableContentTypes)"
                            case .unacceptableStatusCode(let code):
                                errorDescription = "Response status code was unacceptable: " + "\(code)"
                            }
                        case .responseSerializationFailed(let reason):
                            errorDescription = "Response serialization failed: " + "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                        }
                        errorDescription =  "Underlying error: " + "\(error.underlyingError ?? RxError.unknown)"
                    } else if let error = error as? URLError {
                        errorDescription = "URLError occurred: " + "\(error)"
                    } else {
                        errorDescription = "Unknown error: " + "\(error)"
                    }
                    Logger.log("API error for \n\t [\((file as! NSString).lastPathComponent): \(line)] \(function):\n\t" + errorDescription + errorReason, color: .red)
                    return Observable.error(error)
                }
                Logger.log("RESPONSE by request - \(response.request?.url?.absoluteString ?? "") \n\t [\((file as! NSString).lastPathComponent): \(line)] \(function):\n\t RESPONSE - \(response) \n\t\(response.timeline)", color: .green)
                let json = JSON(response.result.value ?? NSNull())
                return Observable.just(json)
        }
    }
    
    func data(_ file: Any = #file, function: Any = #function, line: Int = #line) -> RxSwift.Observable<Data> {
        return RxAlamofire.requestData(self)
            .catchError { error in
                Logger.log("API error for \n\t \(error.localizedDescription)", color: .red)
                return Observable.error(error)
            }
            .shareReplay(1)
            .flatMapLatest { response -> RxSwift.Observable<Data> in
                guard 200 ... 299 ~= response.0.statusCode else {
                    Logger.log("API error for \n\t [\((file as! NSString).lastPathComponent): \(line)] \(function):\n\t" + "status code: \(response.0.statusCode)", color: .red)
                    return Observable.error(NSError.init(domain: "", code: response.0.statusCode, userInfo: nil))
                }
                if response.0.statusCode == 204 {
                    Logger.log("RESPONSE by request - \(response.0.url?.absoluteString ?? "") data is empty \n\t [\((file as! NSString).lastPathComponent): \(line)] \(function):\n\t" + "status code: \(response.0.statusCode)", color: .green)
                    return Observable.error(NSError.init(domain: "", code: response.0.statusCode, userInfo: nil))
                }
                Logger.log("RESPONSE by request - \(response.0.url?.absoluteString ?? "") \n\t [\((file as! NSString).lastPathComponent): \(line)] \(function):\n\t RESPONSE - \(response)", color: .green)
                return Observable.just(response.1)
        }
    }
    
    func response(_ file: Any = #file, function: Any = #function, line: Int = #line) -> RxSwift.Observable<(HTTPURLResponse, String)> {
        return RxAlamofire.requestString(self)
            .catchError { error in
                Logger.log("API error for \n\t \(error.localizedDescription)", color: .red)
                return Observable.error(error)
            }
            .shareReplay(1)
            .flatMapLatest { response, string -> RxSwift.Observable<(HTTPURLResponse, String)> in
                Logger.log("RESPONSE by request - \(response.url?.absoluteString ?? "") \n\t [\((file as! NSString).lastPathComponent): \(line)] \(function):\n\t RESPONSE - \(response)", color: .green)
                guard 200 ... 299 ~= response.statusCode else {
                    Logger.log("API error for \n\t [\((file as! NSString).lastPathComponent): \(line)] \(function):\n\t" + "status code: \(response.statusCode)", color: .red)
                    return Observable.error(NSError.init(domain: "", code: response.statusCode, userInfo: nil))
                }
                return Observable.just((response, string))
        }
    }
}
