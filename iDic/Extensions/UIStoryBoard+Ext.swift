//
//  UIStoryBoard+Ext.swift
//  ContentViewerSwift
//
//  Created by Yura Granchenko on 8/8/17.
//  Copyright © 2017 Adviscent. All rights reserved.
//

import Foundation
import UIKit

struct StoryboardObject<T: UIViewController> {
    let identifier: String
    var storyboard: UIStoryboard
    init(_ identifier: String, _ storyboard: UIStoryboard = UIStoryboard.main) {
        self.identifier = identifier
        self.storyboard = storyboard
    }
    func instantiate() -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    func instantiate(_ block: (T) -> Void) -> T {
        let controller = instantiate()
        block(controller)
        return controller
    }
}

extension UIStoryboard {
    
    @nonobjc static let main = UIStoryboard(name: "Main", bundle: nil)

    func present(_ animated: Bool) {
        UINavigationController.main.viewControllers = [instantiateInitialViewController()!]
    }
    
    subscript(key: String) -> UIViewController? {
        return instantiateViewController(withIdentifier: key)
    }
}

extension UIWindow {
    @nonobjc static let mainWindow = UIApplication.shared.windows.first ??
        UIWindow(frame: UIScreen.main.bounds)
}

extension UINavigationController {
    
    @nonobjc static let main = specify(UINavigationController()) {
        UIWindow.mainWindow.rootViewController = $0
        $0.isNavigationBarHidden = true
    }
    
    open override var shouldAutorotate : Bool {
        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
}
