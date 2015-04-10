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
        self.normalSoundURL = SoundFiles.bassDrumSound
    }
}
