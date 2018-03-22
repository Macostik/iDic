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
import Lottie
import SnapKit

class LoginViewController: BaseViewController, ViewModelBased,
StoryboardBased, GIDSignInDelegate, GIDSignInUIDelegate {
    
    typealias ViewModel = LoginViewModel
    var viewModel: ViewModel?
    
    @IBOutlet var emailTextField: TextField!
    @IBOutlet var passwordTextField: TextField!
    @IBOutlet var emailLabel: Label!
    @IBOutlet var passwordLabel: Label!
    @IBOutlet var signinButton: Button!

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        bindingViewModel()
    }
    
    private func bindingViewModel() {
        viewModel?.email = self.emailTextField.rx.text.orEmpty
            .filter({!$0.isEmpty})
            .asDriver(onErrorJustReturn: "")
        viewModel?.password = self.passwordTextField.rx.text.orEmpty.asDriver()
        viewModel?.loginTap = self.signinButton.rx.tap.do(onNext: {[unowned self] _ in
            self.signinButton.loading = true
        }).asDriver(onErrorJustReturn: Void())
        
        viewModel?.emailValidation
            .drive(emailLabel.rx.validatationResult)
            .disposed(by: disposeBag)
        viewModel?.passwordValidation
            .drive(passwordLabel.rx.validatationResult)
            .disposed(by: disposeBag)
        viewModel?.isAllow.drive(onNext: { [weak self] isValid in
            self?.signinButton.active = isValid
        }).disposed(by: disposeBag)
        viewModel?.reachable.drive(onNext: { [weak self] _ in
            self?.view.add(specify(LOTAnimationView(name: "no_internet_connection"), {
                $0.play()
                $0.loopAnimation = true
            }), {
                $0.top.trailing.equalTo((self?.view ?? UIView())).inset(10)
                $0.size.equalTo(60)
            })
        }).disposed(by: disposeBag)
        viewModel?.signin
            .drive(onNext: { [weak self] result in
                print("User signed in \(result)")
                self?.signinButton.loading = false
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func facebookLogin(sender: AnyObject) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success:
                print("Logged in!")
            }
        }
    }
    
    @IBAction func signInGoogle(sender: AnyObject) {
        GIDSignIn.sharedInstance().clientID = "432215080080-" +
        "rb1s29o1ftfvo47o1l7p3ooo8j14a9ve.apps.googleusercontent.com"
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
            _ = user.userID
            _ = user.authentication.idToken
            _ = user.profile.name
            _ = user.profile.givenName
            _ = user.profile.familyName
            _ = user.profile.email
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
    }
}
