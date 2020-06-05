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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let EXIT_MESSAGE = "Going to exit....."
    private let EMPTY_CRED_MESSAGE = "Empty username/password!"
    private let INVALID_CRED_MESSAGE = "Wrong username/password!"
    private let LOG_IN_MESSAGE = "Login Success!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        print(#function)
        
        runOnMainThread(initTask: {
            ToastPresenter.shared.show(in: self.view, message: self.EXIT_MESSAGE)
        }, delayedTask: {
            exit(EXIT_SUCCESS)
        },delay: 1.0)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        let trimmedUserName = tfUserName.text!.trimmingCharacters(in: .whitespaces)
        let trimmedPassword = tfPassword.text!.trimmingCharacters(in: .whitespaces)
        
        if trimmedUserName.isEmpty || trimmedPassword.isEmpty{
            ToastPresenter.shared.show(in: self.view, message: self.EMPTY_CRED_MESSAGE,timeOut: 1.0)
            return
        }
        disableLoginbuttons()
        WebService
            .INSTANCE
            .login(
                userName: tfUserName.text!,
                password: tfPassword.text!,
                doOnSuccess: {
                    self.runOnMainThread(0.0){
                        ToastPresenter.shared.show(in: self.view, message: self.LOG_IN_MESSAGE,timeOut: 1.0)
                        LocalPersistenceService.INSTANCE.saveLogin(userName: trimmedUserName, passWord: trimmedPassword)
                        self.jumpToSignIn()
                    }
                },
                doOnFailure: {
                    self.runOnMainThread(0.0){
                        self.enableLoginbuttons()
                        ToastPresenter.shared.show(in: self.view, message: self.INVALID_CRED_MESSAGE,timeOut: 1.0)
                    }
                }
            )
    }
    
    @IBAction func appLogoPressed(_ sender: UIButton) {
        WebService.INSTANCE.testApi()
    }
    
    private func disableLoginbuttons(){
        loginButton.isEnabled = false
        cancelButton.isEnabled = false
    }
    
    private func enableLoginbuttons(){
        loginButton.isEnabled = true
        cancelButton.isEnabled = true
    }
    
    private func jumpToSignIn(){
        runOnMainThread(1.0, {
            self.performSegue(withIdentifier: ConstantDefs.SegueNames.LOGIN_TO_SIGN_IN, sender: self)
        })
    }
}

