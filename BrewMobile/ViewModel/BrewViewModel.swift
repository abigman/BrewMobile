//
//  BrewViewModel.swift
//  BrewMobile
//
//  Created by Agnes Vasarhelyi on 04/01/15.
//  Copyright (c) 2015 Ágnes Vásárhelyi. All rights reserved.
//

import Foundation
import ReactiveCocoa

class BrewViewModel : NSObject {
    let stopCommand: RACCommand!
    let tempChangedSignal: RACSignal!
    let brewChangedSignal: RACSignal!
    let socketErrorSignal: RACSignal!

    let brewManager: BrewManager

    var state = BrewState()
    var temp: Float = 0.0

    init(brewManager: BrewManager) {
        
        self.brewManager = brewManager
    
        super.init()
        self.brewManager.connectToHost()

        stopCommand = RACCommand() {
            Void -> RACSignal in
            return brewManager.stopBrewCommand.execute(nil).deliverOn(RACScheduler.mainThreadScheduler())
        }
        
        tempChangedSignal = self.brewManager.tempChangedSignal.map {
            (any: AnyObject!) -> AnyObject! in
            if let anyDict = any as? Dictionary<String, Float> {
                if let newTemp = anyDict[tempChangedEvent] {
                    return newTemp
                }
            }
            return 0
        }.deliverOn(RACScheduler.mainThreadScheduler())
        
        brewChangedSignal = self.brewManager.brewChangedSignal.map {
            (any: AnyObject!) -> AnyObject! in
            if let anyDict = any as? Dictionary<String, BrewState> {
                if let brew = anyDict[brewChangedEvent] {
                    //might be better to just return the brew object for rendering instead of storing its state
                    self.state = brew
                    return brew
                }
            }
            return nil
        }.deliverOn(RACScheduler.mainThreadScheduler())
    }

}