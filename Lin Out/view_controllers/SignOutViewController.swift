//
//  SignOutViewController.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import UIKit
import DCToastView
import CoreLocation

class SignOutViewController: LocationEnabledViewController {
    
    @IBOutlet weak var tvUserName: UILabel!
    @IBOutlet weak var tvAddress: UILabel!
    @IBOutlet weak var tvSignInDuration: UILabel!
    @IBOutlet weak var tfClosingComments: UITextField!
    
    private var signInTime : Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Date().timeIntervalSince(LocalPersistenceService.INSTANCE.getSignIntime()!))
        signInTime = LocalPersistenceService.INSTANCE.getSignIntime()!
        updateDuration()
    }
    
    private func updateDuration() {
        tvSignInDuration.text = "Sign In duration: \(dateToDiffString(date: signInTime!))"
        runOnMainThread(1.0){
            self.updateDuration()
        }
    }
    
    override func initDisplay() {
        tvUserName.text = "User: \(LocalPersistenceService.INSTANCE.getLoggedInUserName()!)"
    }
    
    override func setAddressLineDisplay(addressLine:String){
        tvAddress.text = addressLine
    }
    
    fileprivate func signOutTask(_ comment: String, _ currentLocation: CLLocation, _ currentAddress: String, _ currentPostCode: String) {
        WebService.INSTANCE.closeSession(with:
            SessionCloseRequest(
                comments: comment,
                lat: currentLocation.coordinate.latitude,
                lan: currentLocation.coordinate.longitude,
                address: currentAddress,
                postCode: currentPostCode,
                macAddress: MacUtils.INSTANCE.getDeviceMac()
            ),onSuccess: {
                self.runOnMainThread{
                    LocalPersistenceService.INSTANCE.clearSignIn()
                    ToastPresenter.shared.show(in: self.view, message: "Session close success", timeOut: 0.5)
                    self.performSegue(withIdentifier: ConstantDefs.SegueNames.SIGN_OUT_TO_LAUNCHER, sender: self)
                }
                print("Session close success")
        },
              onFailure: {
                self.runOnMainThread{
                    ToastPresenter.shared.show(in: self.view, message: "Session close failed", timeOut: 2.0)
                }
                print("Session close failed")
        }
        )
    }
    
    @IBAction func signOutPressed(_ sender: RoundButton) {
        
        guard let currentLocation = location,
            let currentAddress = addressLine,
            let currentPostCode = postCode else {
            ToastPresenter.shared.show(in: self.view, message: "Please wait for location update.", timeOut: 2.0)
            return
        }
        
        let comment = tfClosingComments.text!.trimmingCharacters(in: .whitespaces)

        if comment.count == 0 {
            ToastPresenter.shared.show(in: self.view, message: "Please input comment text.", timeOut: 2.0)
            return
        }
        
        print(currentLocation)
        print(currentAddress)
        print(currentPostCode)
        
        showAlertDialog(title: "Sign Out?", message: nil, positiveButtonTask: {
            self.signOutTask(comment, currentLocation, currentAddress, currentPostCode)
        })
    }
    
    private func dateToDiffString(date:Date) -> String{
        var diff = Int(Date().timeIntervalSince(date))
        var dateString = ""
        if diff < 0 {
            dateString.append("-")
        }
        diff = abs(diff)
        
        let hr = diff / 3600
        diff = diff - hr * 3600
        
        let min = diff / 60
        let sec = diff - min * 60
        
        dateString.append("\(hr):\(min):\(sec)")
        
        return dateString
    }
    
}
