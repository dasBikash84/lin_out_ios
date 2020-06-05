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

class SignInViewController: UIViewController {
    
    @IBOutlet weak var tvUserName: UILabel!
    @IBOutlet weak var tvAddress: UILabel!
    @IBOutlet weak var tfCustomerId: UITextField!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    private var location:CLLocation? = nil
    private var addressLine:String? = nil
    private var postCode: String? = nil
    
    private let initLocationUpdateInterval = 1
    private var locationUpdateRetry = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
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
        
    }
    
    func initDisplay() {
        tvUserName.text = "User: \(LocalPersistenceService.INSTANCE.getLoggedInUserName()!)"
    }
    
}

extension SignInViewController : CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
            case .notDetermined:
                print("notDetermined")
                locationManager.requestAlwaysAuthorization()
            
            case .restricted,.denied:
                print("restricted/denied")
                exitForNoLocation()
            
            case .authorizedAlways,.authorizedWhenInUse:
                print("authorizedAlways/authorizedWhenInUse")
                initDisplay()
                locationManager.requestLocation()
            @unknown default:
                exitForNoLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Got location!")
        
        if locations.count > 0 {
            self.location = locations[0]
            geocode(location: self.location!, completion: {
                (placemark:[CLPlacemark]?,error: Error?) in
                
                if placemark != nil && placemark!.count>0{
                    self.addressLine = placemark![0].addressString
                    self.postCode = placemark![0].postalCode
                    self.tvAddress.text = self.addressLine
                }
                if error != nil{
                    print("Geocoder error: \(error!)")
                    self.retryLocationUpdate()
                }
            })
        }else{
            retryLocationUpdate()
        }
    }
    
    private func retryLocationUpdate() {
        runOnMainThread(Double(locationUpdateRetry * locationUpdateRetry * initLocationUpdateInterval )){
            self.locationManager.requestLocation()
        }
        locationUpdateRetry += 1
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update error: \(error)")
        retryLocationUpdate()
    }
    
    func geocode(location:CLLocation, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        print("Requesting geocoder")
        self.geoCoder
            .reverseGeocodeLocation(location,completionHandler: completion)
    }
}
