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
        self.normalSoundURL = SoundFiles.snareDrumSound
    }

    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}