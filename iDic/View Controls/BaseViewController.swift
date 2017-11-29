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
