//
//  XFlatLens.swift
//  Planck
//
//  Created by Wang Jinghan on 10/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class XFlatLens: XNode {
    init(flatLens: GOFlatLensRep) {
        super.init(physicsBody: flatLens)
        self.strokeColor = DeviceColor.lens
        self.normalNote = XNote(noteName: XNoteName.bassDrum, noteGroup: nil, instrument: nil)
    }

    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOFlatLensRep
        let isFixed = aDecoder.decodeBoolForKey("isFixed")
        self.init(flatLens: body)
        self.isFixed = isFixed
//        self.normalNote = normalNote
        self.planckNote = planckNote
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isFixed, forKey: "isFixed")
        aCoder.encodeObject(self.normalNote, forKey: "normalNote")
        aCoder.encodeObject(self.planckNote, forKey: "planckNote")
    }

}
