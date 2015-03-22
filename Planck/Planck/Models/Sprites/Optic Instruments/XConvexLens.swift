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
    var medium: XMedium
    
    init(focus: CGFloat, direction: CGVector, medium: XMedium) {
        self.focus = focus
        self.medium = medium
        super.init(
            texture: nil,
            color: LensDefaults.textureColor,
            size: LensDefaults.convexLenSize
        );
        self.direction = CGVector.vectorFromRadius(direction.angleFromXPlusScalar)
        self.setUp()
    }

    required convenience init(coder aDecoder: NSCoder) {
        let direction = aDecoder.decodeCGVectorForKey(NSCodingKey.Direction)
        let focus:CGFloat = CGFloat(aDecoder.decodeFloatForKey(NSCodingKey.Focus))
        let rawEnumString = aDecoder.decodeObjectForKey(NSCodingKey.Medium1)! as Int
        let medium = XMedium(rawValue: rawEnumString)!
        self.init(focus: focus, direction: direction, medium: medium)
        self.position = aDecoder.decodeCGPointForKey(NSCodingKey.Position)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeCGVector(direction, forKey: NSCodingKey.Direction)
        aCoder.encodeCGPoint(self.position, forKey: NSCodingKey.Position)
        aCoder.encodeFloat(Float(self.focus), forKey: NSCodingKey.Focus)
        aCoder.encodeObject(self.medium.rawValue, forKey: NSCodingKey.Medium1)
    }
    
    private func setUp() {
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