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
        self.normalNote = XNote(noteName: XNoteName.cymbal, noteGroup: 0)
    }

    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOFlatLensRep
        let isPlanck = aDecoder.decodeBoolForKey("isPlanck")
        let shouldPlaySould = aDecoder.decodeBoolForKey("shouldPlaySound")
        self.init(flatLens: body)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isPlanck, forKey: "isPlanck")
        aCoder.encodeBool(self.shouldPlaySound, forKey: "shouldPlaySound")
    }

}
