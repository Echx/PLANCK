//
//  XConvexLens.swift
//  Planck
//
//  Created by Lei Mingyu on 05/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class XConvexLens: XNode {
    init(convexLens: GOConvexLensRep) {
        super.init(physicsBody: convexLens)
        self.strokeColor = DeviceColor.lens
        self.normalNote = XNote(noteName: XNoteName.bassDrum, noteGroup: nil, instrument: nil)
    }

    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOConvexLensRep
        let isFixed = aDecoder.decodeBoolForKey("isFixed")
        let normalNote = aDecoder.decodeObjectForKey("normalNote") as XNote
        let planckNote = aDecoder.decodeObjectForKey("planckNote") as XNote
        
        self.init(convexLens: body)
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
