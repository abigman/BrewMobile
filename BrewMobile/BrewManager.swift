//
//  BrewManager.swift
//  BrewMobile
//
//  Created by Agnes Vasarhelyi on 03/01/15.
//  Copyright (c) 2015 Ágnes Vásárhelyi. All rights reserved.
//

import Foundation
import SwiftyJSON
import ReactiveCocoa
import LlamaKit
import SocketIOFramework

let tempChangedEvent = "temperature_changed"
let brewChangedEvent = "brew_changed"

class BrewManager : NSObject {
    let host = "http://brewcore-demo.herokuapp.com/"
    
    let stopBrewCommand: RACCommand!
    let syncBrewCommand: RACCommand!
    let tempChangedSignal: RACSubject
    let brewChangedSignal: RACSubject
    
    override init() {
        tempChangedSignal = RACSubject()
        brewChangedSignal = RACSubject()
        
        super.init()

        syncBrewCommand = RACCommand(signalBlock: { (brewObject: AnyObject!) -> RACSignal! in
            return self.composeRequestSignalFromURLRequest(self.requestWithBody("api/brew", method: "POST", body: JSON(brewObject)).value()!)
        })
        
        stopBrewCommand = RACCommand(signalBlock: { Void -> RACSignal! in
            return  self.composeRequestSignalFromURLRequest(self.requestWithBody("api/brew/stop", method: "PATCH", body: "").value()!)
        })
    }

    //Mark: HTTP
    
    private func requestWithBody(path: String, method: String, body: JSON) -> Result<NSMutableURLRequest> {
        var request : NSMutableURLRequest = NSMutableURLRequest()
        var serializationError: NSError?
        
        request.URL = NSURL(string: host + path)
        request.HTTPMethod = method
        if method == "POST" {
            request.HTTPBody = body.rawData(options: .PrettyPrinted, error: &serializationError)
        }
        
        return (serializationError == nil ? success(request) : failure(serializationError!))
    }
    
    private func composeRequestSignalFromURLRequest(request: NSMutableURLRequest) -> RACSignal {
        let scheduler = RACScheduler(priority: RACSchedulerPriorityBackground)
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {
                (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if error == nil {
                    subscriber.sendNext(JSON(data).object)
                    subscriber.sendCompleted()
                } else {
                    subscriber.sendError(error)
                }
            })
            return RACDisposable()
        }).subscribeOn(scheduler)
    }
    
    // MARK: WebSocket
    
    func connectToHost() {
        SIOSocket.socketWithHost(self.host, reconnectAutomatically: true, attemptLimit: 0, withDelay: 1, maximumDelay: 5, timeout: 20, response: {socket in
            socket.onConnect = {
                println("Connected to \(self.host)")
            }
            
            socket.onDisconnect = {
                println("Disconnected from \(self.host)")
            }
            
            socket.on(tempChangedEvent, callback: { (AnyObject data) -> Void in
                if(countElements(data) > 0) {
                    self.tempChangedSignal.sendNext([tempChangedEvent: data[0] as Float])
                }
            })
            
            socket.on(brewChangedEvent, callback: { (AnyObject data) -> Void in
                if(countElements(data) > 0) {
                    self.brewChangedSignal.sendNext([brewChangedEvent: ContentParser.parseBrewState(JSON(data[0]))])
                }
            })
            
            socket.onError = { (AnyObject anyError) -> Void in
                
            }
        })
    }
}
