//
//  ViewController.swift
//  LocationUpdate
//
//  Created by Insight Workshop on 8/9/19.
//  Copyright © 2019 Skyway Innovation. All rights reserved.
//

import UIKit
import MapKit

class Cab: NSObject {
    
    var id: Int!
    var latitude: Double!
    var longitude: Double!
    var annotation: MKPointAnnotation?
    
    init(with id: Int, latitude: Double, longitude: Double) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(with json: [String: AnyObject]) {
        guard let id = json["id"] as? Int,
            let latitude = json["latitude"] as? Double,
            let longitude = json["longitude"] as? Double else { return nil }
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func updateLocation(with cabInfo: Cab) {
        if let _ = annotation {} else {
            annotation =  MKPointAnnotation()
        }
        latitude = cabInfo.latitude
        longitude = cabInfo.longitude
        UIView.animate(withDuration: 0.25) {
            self.annotation?.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        }
        
    }
    
    @discardableResult
    func getAnnotation() -> MKPointAnnotation {
        if let _ = annotation {} else {
            annotation =  MKPointAnnotation()
        }
        annotation?.title = "\(id!)"
        annotation?.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return annotation!
    }
    
}

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    var cabs: [Cab] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
        //set socket url string here
        LocationHandler.shared.addListener(self)
    }
    
    private func setUpMapView() {
        mapView.delegate = self
    }
    
    deinit {
        LocationHandler.shared.removeListener(self)
        LocationHandler.shared.close()
    }

}

extension ViewController: MKMapViewDelegate {
    
    private func addNewAnnotation(for cab: Cab) {
        mapView.addAnnotation(cab.getAnnotation())
    }
    
}

extension ViewController: LocationChangeListener {
    
    func didUpdateLocation(of cab: Cab) {
        
        if let index = cabs.firstIndex(where: { (singleCab) -> Bool in
            return singleCab.id == cab.id
        }) {
            cabs[index].updateLocation(with: cab)
        } else {
            cabs.append(cab)
            addNewAnnotation(for: cab)
        }
    }
    
}

