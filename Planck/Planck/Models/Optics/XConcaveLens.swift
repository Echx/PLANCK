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
        self.normalSoundURL = SoundFiles.bassDrumSound
    }
}
