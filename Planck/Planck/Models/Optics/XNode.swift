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
            println("play isPlanck")
            return self.planckNote?.getAudioFile()
        } else {
            println("play isPlanck")
            return self.normalNote?.getAudioFile()
        }
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOOpticRep
        let isFixed = aDecoder.decodeBoolForKey("isFixed")
        let planckNote = aDecoder.decodeObjectForKey("planckNote") as XNote?
        let instrument = aDecoder.decodeObjectForKey("instrument") as Int
        
        self.init(physicsBody: body)
        self.isFixed = isFixed
        self.instrument = instrument
        self.planckNote = planckNote
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isFixed, forKey: "isFixed")
        aCoder.encodeObject(self.instrument, forKey: "instrument")
        
        if self.planckNote != nil {
            aCoder.encodeObject(self.planckNote, forKey: "planckNote")
        }
    }
}
