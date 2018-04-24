//
//  BaseViewController.swift
//  iDic
//
//  Created by Yura Granchenko on 11/29/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModelBased: class {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
}

struct LastVisibleScreen {
    static var lastAppearedScreenName: String = ""
}

class BaseViewController: UIViewController {
    
    var screenName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenName = NSStringFromClass(type(of: self))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LastVisibleScreen.lastAppearedScreenName = screenName
    }
    
    deinit {
        Logger.log("\(NSStringFromClass(type(of: self))) deinit", color: .blue)
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

extension StoryboardBased where Self: UIViewController & ViewModelBased {
    static func instantiate(with viewModel: ViewModel) -> Self {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}
