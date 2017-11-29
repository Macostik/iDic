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

class APIManager {
    var disposeBag = DisposeBag()
    static let shared = APIManager()
    
    func signup(_ email: String, password: String) -> RxSwift.Observable<Any> {
        let url = URL(string: "https://idic.herokuapp.com/api/auth/register")!
        let parameters = [  "email" : email,
                            "name" : "Yuriy",
                            "password" : password  ]
        return request(method: .post, url: url, parameters: parameters)
    }
    
    fileprivate func request(_ line: Int = #line,
                             function: Any = #function,
                             method: Alamofire.HTTPMethod,
                             url: URLConvertible,
                             parameters:[String: Any]? = nil,
                             encoding: ParameterEncoding = URLEncoding.default,
                             headers: [String: String]? = nil) -> RxSwift.Observable<Any> {
        Logger.log("REQUEST for \n\t function - \(function): \(line) line \n\t url - \(url)\n\t method - \(method)\n\t headers - \(headers ?? [:])\n\t parameters - \(parameters ?? [:])", color: .yellow)
        return RxAlamofire.request(.post, url, parameters: parameters)
            .catchError { error in
                Logger.log(error.localizedDescription, color: .red)
                return Observable.never()
            }
            .responseJSON()
            .flatMapLatest{ response -> RxSwift.Observable<Any> in
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
                    Logger.log("API error for \n\t function - \(function): \(line) line\n\t" + errorDescription + errorReason, color: .red)
                    return Observable.never()
                }
                Logger.log("RESPONSE for \n\t function - \(function): \(line) line \n\t RESPONSE - \(response)\n\t\(response.timeline)", color: .green)
                return Observable.just(response)
        }
    }
}

