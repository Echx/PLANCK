//
//  XFlatWall.swift
//  Planck
//
//  Created by Lei Mingyu on 05/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class XFlatWall: XNode {
    init(flatWall: GOFlatWallRep) {
        super.init(physicsBody: flatWall)
        self.normalSoundURL = SoundFiles.cymbalSound
    }

    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOFlatWallRep
        let isPlanck = aDecoder.decodeBoolForKey("isPlanck")
        let shouldPlaySould = aDecoder.decodeBoolForKey("shouldPlaySound")
        self.init(flatWall: body)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isPlanck, forKey: "isPlanck")
        aCoder.encodeBool(self.shouldPlaySound, forKey: "shouldPlaySound")
    }

}

