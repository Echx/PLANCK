//
//  XEmitter.swift
//  Planck
//
//  Created by Wang Jinghan on 11/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

// This class is a subclass of XNode. 
// a emitter is the device that generate light for the game play; however, there
// is no much attribute associated with this kind of device, when light hit the
// emitter, the light will disappear just like hitting the wall
class XEmitter: XNode {
    init(emitter: GOEmitterRep) {
        super.init(physicsBody: emitter)
        self.strokeColor = DeviceColor.emitter
        self.instrument = NodeDefaults.instrumentNil
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey(NSCodingKey.XNodeBody) as GOEmitterRep
        let isFixed = aDecoder.decodeBoolForKey(NSCodingKey.XNodeFixed)
        
        self.init(emitter: body)
        self.isFixed = isFixed
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: NSCodingKey.XNodeBody)
        aCoder.encodeBool(self.isFixed, forKey: NSCodingKey.XNodeFixed)
    }
}
