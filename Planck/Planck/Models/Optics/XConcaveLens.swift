//
//  XConcaveLens.swift
//  Planck
//
//  Created by Lei Mingyu on 05/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class XConcaveLens: XNode {
    init(concaveRep: GOConcaveLensRep) {
        super.init(physicsBody: concaveRep)
        self.strokeColor = DeviceColor.lens
        self.normalNote = XNote(noteName: XNoteName.bassDrum, noteGroup: 0)
    }

    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOConcaveLensRep
        let isPlanck = aDecoder.decodeBoolForKey("isPlanck")
        let shouldPlaySould = aDecoder.decodeBoolForKey("shouldPlaySound")
        self.init(concaveRep: body)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isPlanck, forKey: "isPlanck")
        aCoder.encodeBool(self.shouldPlaySound, forKey: "shouldPlaySound")
    }
}
