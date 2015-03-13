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
        self.direction = CGVector.vectorFromRadius(direction.angleFromXPlusScalar)
        super.init(
            texture: nil,
            color: MirrorDefaults.textureColor,
            size: MirrorDefaults.flatMirrorSize
        );
        
        self.setUp()
    }
    
    override func getNewDirectionAfterReflect(directionIn: CGVector) -> CGVector {
        var mirrorAngle = self.direction.angleFromXPlusScalar
        var inAngle = directionIn.angleFromXPlus
        var outAngle = 2 * self.direction.angleFromXPlus - directionIn.angleFromXPlus
        return CGVector.vectorFromRadius(outAngle)
    }
    
    private func setUp() {
        println("\(direction.angleFromYPlus)")
        self.runAction(SKAction.rotateToAngle(-direction.angleFromYPlus, duration: 0.0));
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