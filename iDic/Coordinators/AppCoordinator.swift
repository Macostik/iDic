//
//  AppCoordinator.swift
//  iDic
//
//  Created by Yura Granchenko on 3/20/18.
//  Copyright © 2018 Yura Granchenko. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let loginCoordinator = LoginCoordinator(window: window)
        return coordinate(to: loginCoordinator)
    }
}
