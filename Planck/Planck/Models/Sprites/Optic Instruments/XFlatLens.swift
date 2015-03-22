//
//  XFlatLens.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class XFlatLens: XLens {
    var medium1: XMedium
    var medium2: XMedium
    
    init(direction: CGVector, medium1: XMedium, medium2: XMedium) {
        self.medium1 = medium1
        self.medium2 = medium2
        super.init(
            texture: nil,
            color: LensDefaults.flatLenColor,
            size: LensDefaults.flatLenSize
        );
        self.direction = CGVector.vectorFromRadius(direction.angleFromXPlusScalar)
        self.setUp()
    }
    
    private func setUp() {
        self.runAction(SKAction.rotateToAngle(-direction.angleFromYPlus, duration: 0.0));
        self.setUpPhysicsProperties()
    }
    
    private func setUpPhysicsProperties() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: LensDefaults.flatLenSize)
        self.physicsBody!.dynamic = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.flatLen
        self.physicsBody!.contactTestBitMask = PhysicsCategory.photon
        self.physicsBody!.collisionBitMask = PhysicsCategory.none
        self.physicsBody!.usesPreciseCollisionDetection = true
    }
    
    override func getNewDirectionAfterRefract(position: CGPoint, direction: CGVector) -> CGVector {
        
        return CGVector(dx: 0.5, dy: 0.5);
    }
}

extension XFlatLens: XContactable {
    func contactWithPhoton(photon: XPhoton) {
        photon.removeActionForKey(ActionKey.photonActionLinear)
        let direction = self.getNewDirectionAfterRefract(photon.position,
                                                         direction: photon.direction)
        photon.setDirection(direction)
        photon.runAction(SKAction.repeatActionForever(photon.getAction()),
                                    withKey: ActionKey.photonActionLinear)
    }
}
