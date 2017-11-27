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
    
    func signup(_ email: String, password: String) -> Observable<UserStatus> {
        let url = URL(string: "https://idic.herokuapp.com/api/auth/register")!
        let parameters = [  "email" : email,
                            "name" : "Yuriy",
                            "password" : password  ]
        return request(.post, url: url, parameters: parameters)
    }
    
    fileprivate func request(_ method: Alamofire.HTTPMethod,
                             url: URLConvertible, parameters:[String: Any]? = nil,
                             encoding: ParameterEncoding = URLEncoding.default,
                             headers: [String: String]? = nil) -> Observable<UserStatus> {
        return RxAlamofire.request(.post, url, parameters: parameters)
//            .debug()
            .catchError { error in
                print (">>self - \(error)<<")
                return Observable.never()
            }
            .responseJSON()
            .flatMapLatest{ response -> Observable<UserStatus> in
                print (">>self - \(response.timeline)<<")
                guard response.error == nil else { return Observable.just(.unavailable) }
                return Observable.just(.authorized(User()))
        }
    }
}

