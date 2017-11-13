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
    
    static let shared = APIManager()
    
    func signup(_ email: String, password: String) -> Observable<Bool> {
        let url = URL(string: "https://idic.herokuapp.com/api/auth/register")!
        let parameters = [  "email" : "y.granchenko@gmail.com",
                            "name" : "Yuriy",
        "password" : "8634"  ] as? [String: Any]
        RxAlamofire.data(.post, url, parameters: parameters)
            .map({ data  in
                print (">>self - \(data)<<")
            })
        return Observable.just(true)
    }
}
