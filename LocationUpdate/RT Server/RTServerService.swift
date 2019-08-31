//
//  RTServeerService.swift
//  RTServerImplementation
//
//  Created by Insight Workshop on 2/20/19.
//  Copyright © 2019 InsightWorkshop. All rights reserved.
//

import Foundation
import SocketIO

class RTServerService: NSObject {
    
    public static let shared = RTServerService()
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    override init() {
        super.init()
    }
    
    func initiate(with address: String) {
        setSocketClientEvents()
        socket.connect()
    }
    
    func disconnect() {
        if socket != nil {
            socket.disconnect()
        }
    }
    
    private func initializeRTServer(with address: String) {
        manager = SocketManager(socketURL: URL(string: address)!, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    
    func getStatus() -> SocketIOStatus {
        return socket.status
    }
    
    func hasSocketInstance() -> Bool {
        return socket != nil
    }
    
}

extension RTServerService {
    
    func post(data: Any, on event: EventType) {
        socket.emitWithAck(event.eventName, with: [data]).timingOut(after: 0) { (data) in
            print(data)
        }
    }
    
}

extension RTServerService {
    
    func removeEvent(of type: EventType) {
        socket.off(type.rawValue)
    }
    
    func createEvent(of type: EventType, completionHandler: @escaping ([Any]) -> Void) {
        socket.on(type.rawValue) { (data, ack) in
            completionHandler(data)
        }
    }
    
}

extension RTServerService {
    
    private func setSocketClientEvents() {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            LocationHandler.shared.joinRoom()
            
        }
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print("socket disconnected")
        }
        
        socket.on(clientEvent: .error) { (data, ack) in
            print("socket error")
        }
        
        socket.on(clientEvent: .ping) { (data, ack) in
            print("socket ping")
        }
        
        socket.on(clientEvent: .pong) { (data, ack) in
            print("socket pong")
        }
        
        socket.on(clientEvent: .reconnect) { (data, ack) in
            print("socket reconnect")
        }
        
        socket.on(clientEvent: .reconnectAttempt) { (data, ack) in
            print("socket reconnectAttempt")
        }
        
        socket.on(clientEvent: .statusChange) { (data, ack) in
            print("socket statusChange")
        }
        
        socket.on(clientEvent: .websocketUpgrade) { (data, ack) in
            print("socket upgrade")
        }
    }
    
}
