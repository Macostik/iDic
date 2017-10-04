//
//  ViewController.swift
//  iDic
//
//  Created by Yura Granchenko on 4/9/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import UIKit
import StreamView
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func facebookLogin(sender: AnyObject) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
            }
        }
    }
}

