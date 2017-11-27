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
    
    func signup(_ email: String, password: String) -> Observable<Bool> {
        let url = URL(string: "https://idic.herokuapp.com/api/auth/register")!
        let parameters = [  "email" : email,
                            "name" : "Yuriy",
                            "password" : password  ]
        return request(.post, url: url, parameters: parameters)
    }
    
    fileprivate func request(_ method: Alamofire.HTTPMethod,
                             url: URLConvertible, parameters:[String: Any]? = nil,
                             encoding: ParameterEncoding = URLEncoding.default,
                             headers: [String: String]? = nil) -> Observable<Bool> {
        return RxAlamofire.requestJSON(.post, url, parameters: parameters)
            .debug()
            .flatMap({ _, _ -> Observable<Bool> in
                return Observable.just(true)
            })
    }
    
}

