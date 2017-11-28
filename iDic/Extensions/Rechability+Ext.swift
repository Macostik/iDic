//
//  Rechability+Ext.swift
//  iDic
//
//  Created by Yura Granchenko on 11/28/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import Foundation
import Reachability
import RxSwift

extension Reactive where Base: Reachability {
    
    static var reachable: Observable<Bool> {
        return Observable.create { observer in
            
            let reachability = Reachability.forInternetConnection()
            
            if let reachability = reachability {
                observer.onNext(reachability.isReachable())
                reachability.reachableBlock = { _ in observer.onNext(true) }
                reachability.unreachableBlock = { _ in observer.onNext(false) }
                reachability.startNotifier()
            } else {
                observer.onError(RxError.timeout)
            }
            
            return Disposables.create {
                reachability?.stopNotifier()
            }
        }
    }
}
