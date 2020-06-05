//
//  SignInViewController.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import UIKit
import CoreLocation
import DCToastView

class SignInViewController : LocationEnabledViewController {
    
    @IBOutlet weak var tvUserName: UILabel!
    @IBOutlet weak var tvAddress: UILabel!
    @IBOutlet weak var tfCustomerId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.delegate = self
        
    }
    
    @IBAction func signInPressed(_ sender: RoundButton) {
        
        guard let currentLocation = location,
            let currentAddress = addressLine,
            let currentPostCode = postCode else {
            ToastPresenter.shared.show(in: self.view, message: "Please wait for location update.", timeOut: 2.0)
            return
        }
        
        let cusId = tfCustomerId.text!.trimmingCharacters(in: .whitespaces)

        if cusId.count == 0 {
            ToastPresenter.shared.show(in: self.view, message: "Please input customer ID.", timeOut: 2.0)
            return
        }
        
        print(currentLocation)
        print(currentAddress)
        print(currentPostCode)
        
        WebService.INSTANCE.openSession(with:
            SessionOpenRequest(
                customerId: cusId,
                lat: currentLocation.coordinate.latitude,
                lan: currentLocation.coordinate.longitude,
                address: currentAddress,
                postCode: currentPostCode,
                macAddress: MacUtils.INSTANCE.getDeviceMac()
            ),onSuccess: {(date:Date) in
                self.runOnMainThread{
                    LocalPersistenceService.INSTANCE.saveSignIn(date: date)
                    ToastPresenter.shared.show(in: self.view, message: "Session open success", timeOut: 0.5)
                    self.performSegue(withIdentifier: ConstantDefs.SegueNames.SIGN_IN_TO_SIGN_OUT, sender: self)
                }
                print("Session open success")
            },
            onFailure: {
                self.runOnMainThread{
                    ToastPresenter.shared.show(in: self.view, message: "Session open failed", timeOut: 2.0)
                }
                print("Session open failed")
            }
        )
    }
    
    @IBAction func logOutPressed(_ sender: RoundButton) {
        LocalPersistenceService.INSTANCE.clearLogin()
        self.performSegue(withIdentifier: ConstantDefs.SegueNames.SIGN_IN_TO_LAUNCHER, sender: self)
    }
    
    override func initDisplay() {
        tvUserName.text = "User: \(LocalPersistenceService.INSTANCE.getLoggedInUserName()!)"
    }
    
    override func setAddressLineDisplay(addressLine:String){
        tvAddress.text = addressLine
    }
    
}
