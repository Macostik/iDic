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

class LoginViewModel {
    var email = Driver.just("")
    var password = Driver.just("")
    var loginTap = Driver.just(Void())
    
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
    lazy var signin: Driver<Any> = self.loginTap.withLatestFrom(permition)
        .flatMapLatest { (email, password) -> Driver<Any> in
            return APIManager.shared.signup(email, password: password).asDriver(onErrorJustReturn: false)
    }
}
