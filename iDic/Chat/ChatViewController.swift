//  
//  ChatViewController.swift
//  iDic
//
//  Created by Yura Granchenko on 3/21/18.
//  Copyright © 2018 Yura Granchenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChatViewController: BaseViewController, StoryboardBased, ViewModelBased {
    
    typealias ViewModel = ChatViewModel
    var viewModel: ViewModel?
    private let disposeBag = DisposeBag()
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        
    }
    private func setupBindings() {
        
    }
}
