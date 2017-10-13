//
//  ViewController.swift
//  iDic
//
//  Created by Yura Granchenko on 4/9/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import UIKit
import FacebookLogin
import GoogleSignIn
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet var emailTextField: TextField!
    @IBOutlet var passwordTextField: TextField!
    @IBOutlet var emailLabel: Label!
    @IBOutlet var passwordLabel: Label!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let userViewModel = UserViewModel(self.emailTextField.rx.text.orEmpty.filter({ $0.count > 0 }).asDriver(onErrorJustReturn: ""), and: self.passwordTextField.rx.text.orEmpty.asDriver())
        
        userViewModel.emailValidation.drive(emailLabel.rx.validatationResult)
        userViewModel.passwordValidation.drive(passwordLabel.rx.validatationResult)
        .disposed(by: disposeBag)
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
    
    @IBAction func signInGoogle(sender: AnyObject) {
        GIDSignIn.sharedInstance().clientID = "432215080080-rb1s29o1ftfvo47o1l7p3ooo8j14a9ve.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
        } else {
            let userId = user.userID
            let idToken = user.authentication.idToken
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
    }
}

