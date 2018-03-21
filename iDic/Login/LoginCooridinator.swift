//
//  LoginCooridinators.swift
//  iDic
//
//  Created by Yura Granchenko on 3/20/18.
//  Copyright © 2018 Yura Granchenko. All rights reserved.
//

import UIKit
import RxSwift

class LoginCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController.instantiate(with: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        
        viewModel.isSignin
            .asObserver()
            .subscribe(onNext: { [unowned self] _ in
                self.showChat(on: viewController)
            })
            .disposed(by: disposeBag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func showChat(on rootViewController: UIViewController) -> Observable<Void> {
        let chatCoordinator = ChatCoordinator(rootViewController: rootViewController)
        return coordinate(to: chatCoordinator)
    }
}
