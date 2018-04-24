//
//  UserViewModel.swift
//  iDic
//
//  Created by Yura Granchenko on 10/11/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Reachability
import SwiftyJSON

class LoginViewModel {
    var email = Driver<String>.empty()
    var password = Driver<String>.empty()
    var loginTap = Driver<Void>.empty()
    var isSignin = PublishSubject<Bool>()
    
    lazy var emailValidation: Driver<ValidateResult> = (self.email.flatMapLatest { email in
        guard email.isValidEmail else { return .just(.failure) }
        return .just(.validate)
    })
    lazy var passwordValidation: Driver<ValidateResult> = password.flatMapLatest { password in
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .just(.empty)
        } else if numberOfCharacters < 5 {
            return .just(.failure)
        }
        return .just(.validate)
        }.asDriver()
    lazy var reachable: Driver<Bool> = Reachability.rx.reachable.asDriver(onErrorJustReturn: true)
    lazy var isAllow: Driver<Bool> = Driver.combineLatest(emailValidation, passwordValidation, reachable) {
        $0.isValid && $1.isValid && $2
        }.distinctUntilChanged()
    lazy var permition = Driver.combineLatest(email, password).map {($0, $1)}
    lazy var signin: Driver<JSON> = self.loginTap.withLatestFrom(permition)
        .flatMapLatest { (email, password) -> Driver<JSON> in
            let a = APIManager.signup(["email" : email, "name" : "Yuriy", "password" : password]).json()
                .do(onNext: { one in
                self.isSignin.onNext(true)
            }).asDriver(onErrorJustReturn: false)
            return a
    }
}
