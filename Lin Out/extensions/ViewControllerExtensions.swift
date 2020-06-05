//
//  ViewControllerExtensions.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import Foundation
import UIKit
import DCToastView

extension UIViewController{
    
    func runOnMainThread(_ delay:Double = 0.0, _  task: @escaping ()->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+delay){
            if(self.isOnScreen){
                task()
            }
        }
    }
    
    func runOnMainThread(initTask: @escaping ()->Void, delayedTask: @escaping ()->Void,delay:Double = 0.0) {
        
        DispatchQueue.main.async{
            initTask()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+delay){
            if(self.isOnScreen){
                delayedTask()
            }
        }
    }
    
    func exitWithMessage(message:String){
        runOnMainThread(initTask: {
            ToastPresenter.shared.show(in: self.view, message: message)
        }, delayedTask: {
            exit(EXIT_FAILURE)
        }, delay : 3.0)
    }
    
    func exitForNoLocation(){
        exitWithMessage(message: ConstantDefs.ErrorMessages.LOCATION_REQUIRD_MESSAGE)
    }
    
    var isOnScreen: Bool{
        return self.isViewLoaded && view.window != nil
    }
    
    
}


