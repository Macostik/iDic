//
//  Results.swift
//  iDic
//
//  Created by Yura Granchenko on 10/10/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum UserStatus {
    case unavailable
    case authorized(User)
}

enum ValidateResult {
    case validate
    case failure
    case empty
}

extension ValidateResult {
    var textColor: UIColor {
        switch self {
        case .validate:
            return UIColor.green
        case .failure:
            return UIColor.red
        case .empty:
            return UIColor.white.withAlphaComponent(0.7)
        }
    }
}

extension ValidateResult {
    var isValid: Bool {
        switch self {
        case .validate:
            return true
        default:
            return false
        }
    }
}

extension Reactive where Base: Label {
    var validatationResult: UIBindingObserver<Base, ValidateResult> {
        return UIBindingObserver(UIElement: base, binding: { label, validateResult in
            label.textColor = validateResult.textColor
        })
    }
}
