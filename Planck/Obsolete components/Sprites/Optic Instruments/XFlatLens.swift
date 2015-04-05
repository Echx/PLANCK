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

    required convenience init(coder aDecoder: NSCoder) {
        let direction = aDecoder.decodeCGVectorForKey(NSCodingKey.Direction)
        let rawEnumString1 = aDecoder.decodeObjectForKey(NSCodingKey.Medium1)! as Int
        let rawEnumString2 = aDecoder.decodeObjectForKey(NSCodingKey.Medium2)! as Int
        let medium1 = XMedium(rawValue: rawEnumString1)!
        let medium2 = XMedium(rawValue: rawEnumString2)!
        self.init(direction: direction, medium1: medium1, medium2: medium2)
        self.position = aDecoder.decodeCGPointForKey(NSCodingKey.Position)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeCGVector(direction, forKey: NSCodingKey.Direction)
        aCoder.encodeCGPoint(self.position, forKey: NSCodingKey.Position)
        aCoder.encodeObject(self.medium1.rawValue, forKey: NSCodingKey.Medium1)
        aCoder.encodeObject(self.medium2.rawValue, forKey: NSCodingKey.Medium2)
    }

    
    private func setUp() {
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
