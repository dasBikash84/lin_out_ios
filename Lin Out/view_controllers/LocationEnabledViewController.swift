//
//  LocationEnabledViewController2.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import UIKit
import CoreLocation

class LocationEnabledViewController : UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    
    private let initLocationUpdateInterval = 1
    private var locationUpdateRetry = 0
    
    var location:CLLocation? = nil
    var addressLine:String? = nil
    var postCode: String? = nil
    
    func initDisplay(){
        fatalError("\(#function) not over-ridden!")
    }
    
    func setAddressLineDisplay(addressLine:String){
        fatalError("\(#function) not over-ridden!")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
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
                    self.setAddressLineDisplay(addressLine: self.addressLine ?? "")
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
