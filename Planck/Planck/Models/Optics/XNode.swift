//
//  XNode.swift
//  Planck
//
//  Created by NULL on 10/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class XNode: NSObject, NSCoding {
    var physicsBody: GOOpticRep
    var instrument: Int = NodeDefaults.instrumentInherit
    var isPlanck: Bool {
        get {
            if (self.instrument == NodeDefaults.instrumentInherit) || (self.instrument == NodeDefaults.instrumentNil) {
                return false
            } else {
                return true
            }
        }
    }
    var shouldPlaySound: Bool {
        get {
            if self.instrument == NodeDefaults.instrumentNil {
                return false
            } else {
                return true
            }
        }
    }
    
    var strokeColor = UIColor.whiteColor()
    var normalNote: XNote?
    var planckNote: XNote?
    var isFixed = true
    
    var id: String {
        get {
            return self.physicsBody.id
        }
    }
    
    init(physicsBody: GOOpticRep) {
        self.physicsBody = physicsBody
        super.init()
    }
    
    func getSound() -> NSURL? {
        if !self.shouldPlaySound {
            return nil
        } else if self.isPlanck {
            return self.planckNote?.getAudioFile()
        } else {
            return self.normalNote?.getAudioFile()
        }
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOOpticRep
        let isFixed = aDecoder.decodeBoolForKey("isFixed")
        self.init(physicsBody: body)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isFixed, forKey: "isFixed")
    }
}
