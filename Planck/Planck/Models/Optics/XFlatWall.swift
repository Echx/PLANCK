//
//  XFlatWall.swift
//  Planck
//
//  Created by Lei Mingyu on 05/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

// XFlatWall represents the wall in this game. When the light hit the wall,
// it will be stopped and the sound of the wall will be played.
class XFlatWall: XNode {
    init(flatWall: GOFlatWallRep) {
        super.init(physicsBody: flatWall)
        self.strokeColor = DeviceColor.wall
        self.normalNote = XNote(noteName: XNoteName.cymbal, noteGroup: nil, instrument: nil)
    }

    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey(NSCodingKey.XNodeBody) as GOFlatWallRep
        let isFixed = aDecoder.decodeBoolForKey(NSCodingKey.XNodeFixed)
        let planckNote = aDecoder.decodeObjectForKey(NSCodingKey.XNodePlanck) as XNote?
        let instrument = aDecoder.decodeObjectForKey(NSCodingKey.XNodeInstrument) as Int
        
        self.init(flatWall: body)
        self.isFixed = isFixed
        self.instrument = instrument
        self.planckNote = planckNote
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: NSCodingKey.XNodeBody)
        aCoder.encodeBool(self.isFixed, forKey: NSCodingKey.XNodeFixed)
        aCoder.encodeObject(self.instrument, forKey: NSCodingKey.XNodeInstrument)
        if self.planckNote != nil {
            aCoder.encodeObject(self.planckNote, forKey: NSCodingKey.XNodePlanck)
        }
    }

}

