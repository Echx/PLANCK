//
//  XFlatMirror.swift
//  Planck
//
//  Created by Lei Mingyu on 05/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class XFlatMirror: XNode {
    init(flatMirror: GOFlatMirrorRep) {
        super.init(physicsBody: flatMirror)
        self.strokeColor = DeviceColor.mirror
        self.normalNote = XNote(noteName: XNoteName.snareDrum, noteGroup: nil, instrument: nil)
    }

    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOFlatMirrorRep
        let isFixed = aDecoder.decodeBoolForKey("isFixed")
        let planckNote = aDecoder.decodeObjectForKey("planckNote") as XNote?
        self.init(flatMirror: body)
        self.isFixed = isFixed
        self.planckNote = planckNote
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isFixed, forKey: "isFixed")
        if self.planckNote != nil {
            aCoder.encodeObject(self.planckNote, forKey: "planckNote")
        }
    }

}