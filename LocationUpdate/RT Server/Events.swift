//
//  Events.swift
//  RTServerImplementation
//
//  Created by Insight Workshop on 2/20/19.
//  Copyright © 2019 InsightWorkshop. All rights reserved.
//

import Foundation

public enum EventType: String, CaseIterable {
    
    case locationChanged = "location"
    
    var eventName: String {
        switch self {
            case .locationChanged: return "location"
        }
    }
    
    static func getEventNameFrom(string: String) -> EventType? {
        for item in EventType.allCases {
            if item.eventName.elementsEqual(string) {
                return item
            }
        }
        return nil
    }
    
}

class Event {
    
    var udid: String!
    var type: EventType
    
    init(with id: String, with type: EventType) {
        self.udid = id
        self.type = type
    }
    
}

