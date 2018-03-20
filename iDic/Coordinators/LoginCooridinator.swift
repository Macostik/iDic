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
        let viewController = LoginViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
//        viewModel.showRepository
//            .subscribe(onNext: { [weak self] in self?.showRepository(by: $0, in: navigationController) })
//            .disposed(by: disposeBag)
//
//        viewModel.showLanguageList
//            .flatMap { [weak self] _ -> Observable<String?> in
//                guard let `self` = self else { return .empty() }
//                return self.showLanguageList(on: viewController)
//            }
//            .filter { $0 != nil }
//            .map { $0! }
//            .bind(to: viewModel.setCurrentLanguage)
//            .disposed(by: disposeBag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }

    
}
