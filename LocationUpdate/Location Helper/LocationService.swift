//
//  LocationService.swift
//  Bio Dash
//
//  Created by Insight Workshop on 1/28/19.
//  Copyright © 2019 Insight Workshop. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let shared : LocationService = {
        let instance = LocationService()
        return instance
    }()
    
    var locationManager:CLLocationManager?
    var currentLocation:CLLocation?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    @discardableResult
    func isLocationEnabled() -> Bool{
        if CLLocationManager.locationServicesEnabled(){
            switch getAuthorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse: return true
            case .denied, .restricted: return false
            case .notDetermined:
                locationManager?.requestWhenInUseAuthorization()
                return true
            }
        }
        return false
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    func requestNewLocation() {
        locationManager?.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: AnyObject? = locations.last
        currentLocation = location as? CLLocation
        sendLocationToApi()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocationServiceConstants.NotificationNames.locationCaptureError),object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocationServiceConstants.NotificationNames.locationServiceAuthorizationStatusChange), object: nil)
    }
    
    // on location update, send the location info to backend.. and backend then process the request body and emits the location back again in all devices
    private func sendLocationToApi() {
        
        guard let coOrdinates = currentLocation?.coordinate else { return }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        //url string to post location
        let url = URL(string: <#String#>)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // your post request data
        let id = Int(arc4random_uniform(6) + 1)
        let postDict : [String: Any] = ["id": id,
                                        "latitude": coOrdinates.latitude,
                                        "longitude" : coOrdinates.longitude ]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            return
        }
        
        urlRequest.httpBody = postData
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
        }
        task.resume()
    }
    
}


