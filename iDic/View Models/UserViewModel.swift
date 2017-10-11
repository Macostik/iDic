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
    fileprivate let emailValidation: Driver<ValidateResult>?
    fileprivate let passwordValidation: Driver<ValidateResult>?
    
    init(_ email: Driver<String>, and password: Driver<String>) {
        emailValidation = email.flatMapLatest{ email in
            guard email.isValidEmail else { return .failure }
            return .validate
        }.asDriver()
        passwordValidation = password.flatMapLatest { password in
            let numberOfCharacters = password.characters.count
            if numberOfCharacters == 0 {
                return .empty
            } else if numberOfCharacters < 5 {
                return .failure
            }
            return .validate
        }
        print (">>self - \(emailValidation), \(passwordValidation)<<")
    }
}
