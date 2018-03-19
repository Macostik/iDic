//
//  Realm+RxSwift+Ext.swift
//  iDic
//
//  Created by Yura Granchenko on 10/10/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

extension Results {
    func asObservable() -> Observable<RealmCollectionChange<Results<Element>>> {
        return Observable.create { observer in
            var token: NotificationToken? = nil
            token = self.addNotificationBlock({ change in
                observer.onNext(change)
            })
            return Disposables.create {
                token?.stop()
            }
        }
    }
}
