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
    init(direction: CGVector) {
        super.init(
            texture: nil,
            color: WallDefaults.textureColor,
            size: WallDefaults.wallSize
        );
        self.direction = CGVector.vectorFromRadius(direction.angleFromXPlusScalar)
        self.setUp()
    }

    required convenience override init(coder aDecoder: NSCoder) {
        let direction = aDecoder.decodeCGVectorForKey(NSCodingKey.Direction)
        self.init(direction: direction)
        self.position = aDecoder.decodeCGPointForKey(NSCodingKey.Position)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeCGVector(direction, forKey: NSCodingKey.Direction)
        aCoder.encodeCGPoint(self.position, forKey: NSCodingKey.Position)
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