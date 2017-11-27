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

class UserViewModel {
    let emailValidation: Driver<ValidateResult>
    let passwordValidation: Driver<ValidateResult>
    let isAllow: Driver<Bool>
    let signin: Driver<UserStatus>
    
    init(email: Driver<String>, password: Driver<String>, loginTap: Driver<Void>) {
        emailValidation = email.flatMapLatest{ email in
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
        isAllow = Driver.combineLatest(emailValidation, passwordValidation) { email, password in
            email.isValid && password.isValid
        }.distinctUntilChanged()
        let permition = Driver.combineLatest(email, password).map {($0, $1)}
        signin = loginTap.withLatestFrom(permition)
            .flatMapLatest{ (email, password) -> Driver<UserStatus> in
               return APIManager.shared.signup(email, password: password).asDriver(onErrorJustReturn: .unavailable)
        }
    }
}
