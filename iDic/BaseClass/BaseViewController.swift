//
//  BaseViewController.swift
//  iDic
//
//  Created by Yura Granchenko on 11/29/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    static var lastAppearedScreenName: String?
    var screenName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenName = NSStringFromClass(type(of: self))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BaseViewController.lastAppearedScreenName = screenName
    }
}

public protocol StoryboardBased: class {
    static var storyboard: UIStoryboard { get }
}

public extension StoryboardBased {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
    }
}

public extension StoryboardBased where Self: UIViewController {
    static func instantiate() -> Self {
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            Logger.log("The VC of \\(sceneStoryboard) is not of class \\(self)", color: .red)
            fatalError()
        }
        return vc
    }
}

protocol ViewModelBased: class {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
}

extension ViewModelBased where Self: StoryboardBased & UIViewController {
    static func instantiate (with viewModel: ViewModel) -> Self {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}
