//
//  XNode.swift
//  Planck
//
//  Created by NULL on 10/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class XNode: NSObject {
    var physicsBody: GOOpticRep
    var isPlanck = false
    var shouldPlaySound = true
    var normalSoundURL: NSURL?
    var planckSoundURL: NSURL? = SoundFiles.cymbalSound
    
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
}
