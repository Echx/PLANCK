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
        self.isPlanck = false
        self.shouldPlaySound = false
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOEmitterRep
        self.init(emitter: body)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
    }
}
