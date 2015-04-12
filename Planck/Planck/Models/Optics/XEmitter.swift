//
//  XEmitter.swift
//  Planck
//
//  Created by NULL on 11/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class XEmitter: XNode {
    init(emitter: GOEmitterRep) {
        super.init(physicsBody: emitter)
        self.strokeColor = DeviceColor.emitter
        self.instrument = NodeDefaults.instrumentNil
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOEmitterRep
        let isFixed = aDecoder.decodeBoolForKey("isFixed")
        
        self.init(emitter: body)
        self.isFixed = isFixed
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isFixed, forKey: "isFixed")
    }
}
