//
//  ViewControllerExtensions.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func runOnMainThread(_ delay:Double = 0.0, _  task: @escaping ()->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+delay){
            task()
        }
    }
    
    func runOnMainThread(initTask: @escaping ()->Void, delayedTask: @escaping ()->Void,delay:Double = 0.0) {
        initTask()
        DispatchQueue.main.asyncAfter(deadline: .now()+delay){
            delayedTask()
        }
    }
    
}
