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
        self.init(flatMirror: body)
        self.isFixed = isFixed
        self.normalNote = normalNote
        self.planckNote = planckNote
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isFixed, forKey: "isFixed")
        aCoder.encodeObject(self.normalNote, forKey: "normalNote")
        aCoder.encodeObject(self.planckNote, forKey: "planckNote")
    }

}