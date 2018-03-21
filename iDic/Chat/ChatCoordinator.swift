//  
//  ChatCoordinator.swift
//  iDic
//
//  Created by Yura Granchenko on 3/21/18.
//  Copyright © 2018 Yura Granchenko. All rights reserved.
//

import UIKit
import RxSwift

class ChatCoordinator: BaseCoordinator<Void> {
    
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        let viewController = ChatViewController.instantiate(with: ChatViewModel())
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return Observable.never()
    }
}
