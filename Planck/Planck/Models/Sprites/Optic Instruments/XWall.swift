//
//  XWall.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import SpriteKit

class XWall: XInsrtument {
    var direction: CGVector
    
    init(direction: CGVector) {
        self.direction = CGVector.vectorFromRadius(direction.angleFromXPlusScalar)
        super.init(
            texture: nil,
            color: WallDefaults.textureColor,
            size: WallDefaults.wallSize
        );
        
        self.setUp()
    }
    
    private func setUp() {
        self.runAction(SKAction.rotateToAngle(-direction.angleFromYPlus, duration: 0.0));
        self.setUpPhysicsProperties()

    }
    
    private func setUpPhysicsProperties() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: WallDefaults.wallSize)
        self.physicsBody!.dynamic = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.wall
        self.physicsBody!.contactTestBitMask = PhysicsCategory.photon
        self.physicsBody!.collisionBitMask = PhysicsCategory.none
        self.physicsBody!.usesPreciseCollisionDetection = true
    }
}

extension XWall: XContactable {
    func contactWithPhoton(photon: XPhoton) {
        photon.removeFromParent()
    }
}