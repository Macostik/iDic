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
    var emailValidation: Driver<ValidateResult>?
    var passwordValidation: Driver<ValidateResult>?
    var isAllow: Driver<Bool>?
    var signin: Driver<Any>?
    var reachable: Driver<Bool>?
    
    func setup(email: Driver<String>, password: Driver<String>, loginTap: Driver<Void>) {
        emailValidation = email.flatMapLatest { email in
            guard email.isValidEmail else { return .just(.failure) }
            return .just(.validate)
        }
        passwordValidation = password.flatMapLatest { password in
            let numberOfCharacters = password.count
            if numberOfCharacters == 0 {
                return .just(.empty)
            } else if numberOfCharacters < 5 {
                return .just(.failure)
            }
            return .just(.validate)
            }.asDriver()
        reachable = Reachability.rx.reachable.asDriver(onErrorJustReturn: true)
        isAllow = Driver.combineLatest(emailValidation, passwordValidation, reachable) {
            $0.isValid && $1.isValid && $2
        }.distinctUntilChanged()
        let permition = Driver.combineLatest(email, password).map {($0, $1)}
        signin = loginTap.withLatestFrom(permition)
            .flatMapLatest { (email, password) -> Driver<Any> in
               return APIManager.shared.signup(email, password: password).asDriver(onErrorJustReturn: false)
        }
    }
}