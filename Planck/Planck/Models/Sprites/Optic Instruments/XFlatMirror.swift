//
//  XFlatMirror.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import SpriteKit

class XFlatMirror: XMirror {
    var direction: CGVector
    
    init(direction: CGVector) {
        self.direction = direction
        super.init(
            texture: nil,
            color: MirrorDefaults.textureColor,
            size: MirrorDefaults.flatMirrorSize
        );
        
        self.setUp()
    }
    
    private func setUp() {
        self.runAction(SKAction.rotateToAngle(direction.angleFromNorm, duration: 0.0));
        self.setUpPhysicsProperties()
    }
    
    private func setUpPhysicsProperties() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: MirrorDefaults.flatMirrorSize)
        self.physicsBody!.dynamic = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.flatMirror
        self.physicsBody!.contactTestBitMask = PhysicsCategory.photon
        self.physicsBody!.collisionBitMask = PhysicsCategory.none
        self.physicsBody!.usesPreciseCollisionDetection = true
    }
}