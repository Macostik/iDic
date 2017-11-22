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
    
    func signup(_ email: String, password: String, completion: @escaping ((Observable<Bool>) -> Void)) {
        let url = URL(string: "https://idic.herokuapp.com/api/auth/register")!
        let parameters = [  "email" : email,
                            "name" : "Yuriy",
                            "password" : password  ]
        RxAlamofire.requestJSON(.post, url, parameters: parameters)
            .debug()
            .subscribe(onNext: { _, json in
                print (">>self - \(json)<<")
                completion(Observable.just(true))
            }).disposed(by: disposeBag)
    }
}
