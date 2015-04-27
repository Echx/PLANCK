//
//  XConvexLens.swift
//  Planck
//
//  Created by Lei Mingyu on 05/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

// XConvexLens represents the convex lens in this game. A convex lens will
// concentrate the incident light and if the angle exceed a certain limit, 
// total reflection will occur
class XConvexLens: XNode {
    init(convexLens: GOConvexLensRep) {
        super.init(physicsBody: convexLens)
        self.strokeColor = DeviceColor.lens
        self.normalNote = XNote(noteName: XNoteName.bassDrum, noteGroup: nil, instrument: nil)
    }

    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey(NSCodingKey.XNodeBody) as! GOConvexLensRep
        let isFixed = aDecoder.decodeBoolForKey(NSCodingKey.XNodeFixed)
        let planckNote = aDecoder.decodeObjectForKey(NSCodingKey.XNodePlanck) as! XNote?
        let instrument = aDecoder.decodeObjectForKey(NSCodingKey.XNodeInstrument) as! Int
        
        self.init(convexLens: body)
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
