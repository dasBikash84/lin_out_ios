//
//  LauncherViewController.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import UIKit

class LauncherViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runOnMainThread(0.5){
            self.goToNextScreen()
        }
    }

    private func launchLogin() {
        self.performSegue(withIdentifier: ConstantDefs.SegueNames.Launcer_TO_LOGIN, sender: self)
    }
    private func launchSignIn() {
        self.performSegue(withIdentifier: ConstantDefs.SegueNames.Launcer_TO_SIGN_IN, sender: self)
    }
    
    private func launchSignOut() {
        self.performSegue(withIdentifier: ConstantDefs.SegueNames.Launcer_TO_SIGN_OUT, sender: self)
    }
    
    private func checkLogin()->Bool{
        return LocalPersistenceService.INSTANCE.checkLogin()
    }
    
    private func checkSignIn()->Bool{
        return LocalPersistenceService.INSTANCE.checkSignIn()
    }
    
    private func goToNextScreen(){
        if checkLogin() {
            if checkSignIn(){
                launchSignOut()
            }else{
                launchSignIn()
            }
        }else{
            launchLogin()
        }
    }
    
}
