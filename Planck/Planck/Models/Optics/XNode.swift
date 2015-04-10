//
//  XNode.swift
//  Planck
//
//  Created by NULL on 10/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class XNode: NSObject, NSCoding {
    var physicsBody: GOOpticRep
    var isPlanck = false
    var shouldPlaySound = true
    var normalSoundURL: NSURL?
    var planckSoundURL: NSURL? = SoundFiles.cymbalSound
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
        if self.isPlanck {
            return self.planckSoundURL
        } else {
            return self.normalSoundURL
        }
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOOpticRep
        let isPlanck = aDecoder.decodeBoolForKey("isPlanck")
        let shouldPlaySould = aDecoder.decodeBoolForKey("shouldPlaySound")
        self.init(physicsBody: body)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isPlanck, forKey: "isPlanck")
        aCoder.encodeBool(self.shouldPlaySound, forKey: "shouldPlaySound")
    }
}
