//
//  ViewController.swift
//  Lin Out
//
//  Created by bikash on 4/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import UIKit
import DCToastView

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        print(#function)
        
        runOnMainThread(initTask: {
            ToastPresenter.shared.show(in: self.view, message: "Going to exit.....")
        }, delayedTask: {
            exit(EXIT_SUCCESS)
        },delay: 1.0)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        WebService.INSTANCE.login(userName: tfUserName.text!, password: tfPassword.text!, doOnSuccess: {print("Success")}, doOnFailure: {print("Failure")})
    }
    
    @IBAction func appLogoPressed(_ sender: UIButton) {
        WebService.INSTANCE.testApi()
    }
    
}

