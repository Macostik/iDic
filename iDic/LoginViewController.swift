//
//  ViewController.swift
//  iDic
//
//  Created by Yura Granchenko on 4/9/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import UIKit
import StreamView
import SnapKit
import Lottie

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let animationView = LOTAnimationView(name: "launch")
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
    }
}

