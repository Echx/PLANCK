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
        self.normalNote = XNote(noteName: XNoteName.snareDrum, noteGroup: 0)
    }

    required convenience init(coder aDecoder: NSCoder) {
        let body = aDecoder.decodeObjectForKey("phyBody") as GOFlatMirrorRep
        let isPlanck = aDecoder.decodeBoolForKey("isPlanck")
        let shouldPlaySould = aDecoder.decodeBoolForKey("shouldPlaySound")
        self.init(flatMirror: body)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.physicsBody, forKey: "phyBody")
        aCoder.encodeBool(self.isPlanck, forKey: "isPlanck")
        aCoder.encodeBool(self.shouldPlaySound, forKey: "shouldPlaySound")
    }

}