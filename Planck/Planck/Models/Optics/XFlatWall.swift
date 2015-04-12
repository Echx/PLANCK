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
        self.strokeColor = DeviceColor.wall
        self.normalNote = XNote(noteName: XNoteName.cymbal, noteGroup: nil, instrument: nil)
    }

    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOFlatWallRep
        let isFixed = aDecoder.decodeBoolForKey("isFixed")
        let planckNote = aDecoder.decodeObjectForKey("planckNote") as XNote?
        let instrument = aDecoder.decodeObjectForKey("instrument") as Int
        
        self.init(flatWall: body)
        self.isFixed = isFixed
        self.instrument = instrument
        self.planckNote = planckNote
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isFixed, forKey: "isFixed")
        aCoder.encodeObject(self.instrument, forKey: "instrument")
        if self.planckNote != nil {
            aCoder.encodeObject(self.planckNote, forKey: "planckNote")
        }
    }

}

