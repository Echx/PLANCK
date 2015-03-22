//
//  XInstrument.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class XInsrtument: XNode {
    var shouldAdjustAppearance = true;
    var direction: CGVector {
        didSet {
            if self.shouldAdjustAppearance {
                self.runAction(SKAction.rotateToAngle(-self.direction.angleFromYPlus, duration: 0.0));
            }
        }
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        self.direction  = InstrumentDefaults.direction;
        super.init(texture: texture, color: color, size: size)
    }
    
    func setDirection(angleFromYPlus: CGFloat) {
        self.shouldAdjustAppearance = false
        self.direction = CGVector.vectorFromYPlusRadius(angleFromYPlus)
        self.shouldAdjustAppearance = true
        self.runAction(SKAction.rotateToAngle(-angleFromYPlus, duration: 0.0));
    }
}