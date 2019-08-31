//
//  LocationHandler.swift
//  LocationUpdate
//
//  Created by Insight Workshop on 8/9/19.
//  Copyright © 2019 Skyway Innovation. All rights reserved.
//

import Foundation

protocol LocationChangeListener: class {
    func didUpdateLocation(of cab: Cab)
}

class LocationHandler: NSObject {
    
    static let shared: LocationHandler = { return LocationHandler() }()
    private var listeners = [LocationChangeListener]()
    
    override init() {
        super.init()
        instantiate()
    }
    
    private func instantiate() {
        RTServerService.shared.initiate(with: <#SocketUrlHere#>)
    }
    
    func joinRoom() {
        removeAllEventListeners()
        RTServerService.shared.createEvent(of: .locationChanged) { (data) in
            if let data = data[0] as? [String:AnyObject], let cab = Cab(with: data) {
                self.notifyLocationChange(with: cab)
            }
        }
    }
    
    private func notifyLocationChange(with cab: Cab) {
        for listener in listeners {
            listener.didUpdateLocation(of: cab)
        }
    }
    
    private func removeAllEventListeners() {
        for event in EventType.allCases {
            RTServerService.shared.removeEvent(of: event)
        }
    }
    
    func close() {
        RTServerService.shared.disconnect()
    }
    
    /// Adds a new listener to the listeners array
    ///
    /// - parameter delegate: a new listener
    func addListener(_ listener: LocationChangeListener){
        listeners.append(listener)
    }
    
    /// Removes a listener from listeners array
    ///
    /// - parameter delegate: the listener which is to be removed
    func removeListener(_ listener: LocationChangeListener){
        listeners = listeners.filter{ $0 !== listener}
    }
    
}

