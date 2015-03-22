//
//  XConvexLens.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import SpriteKit

class XConvexLens: XLens {
    var focus:CGFloat
    var direction: CGVector
    var medium: XMedium
    
    init(focus: CGFloat, direction: CGVector, medium: XMedium) {
        self.focus = focus
        self.direction = CGVector.vectorFromRadius(direction.angleFromXPlusScalar)
        self.medium = medium
        super.init(
            texture: nil,
            color: LensDefaults.textureColor,
            size: LensDefaults.convexLenSize
        );
        
        self.setUp()
    }
    
    private func setUp() {
        self.runAction(SKAction.rotateToAngle(-direction.angleFromYPlus, duration: 0.0));
        self.setUpPhysicsProperties()
    }
    
    private func setUpPhysicsProperties() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: LensDefaults.convexLenSize)
        self.physicsBody!.dynamic = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.convexLen
        self.physicsBody!.contactTestBitMask = PhysicsCategory.photon
        self.physicsBody!.collisionBitMask = PhysicsCategory.none
        self.physicsBody!.usesPreciseCollisionDetection = true
    }
    
    private func calculateFocusPoint(lensCenter: CGPoint) -> CGPoint{
        return CGPoint(x: lensCenter.x + focus + self.size.width / 2, y: lensCenter.y);
    }
}

extension XConvexLens: XContactable {
    func contactWithPhoton(photon: XPhoton) {
        
        photon.removeFromParent()
    }
}