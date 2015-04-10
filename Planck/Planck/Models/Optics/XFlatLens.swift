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
        self.normalSoundURL = SoundFiles.cymbalSound
    }
}
