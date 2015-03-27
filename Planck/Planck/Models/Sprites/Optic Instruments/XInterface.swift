//
//  XInterface.swift
//  Planck
//
//  Created by Jinghan on 22/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit
import SpriteKit

class XInterface: XInsrtument {
    var medium1: XMedium
    var medium2: XMedium
    
    init(direction: CGVector, medium1: XMedium, medium2: XMedium) {
        self.medium1 = medium1
        self.medium2 = medium2
        super.init(
            texture: nil,
            color: InterfaceDefaults.color,
            size: CGSizeMake(InterfaceDefaults.thickness, InterfaceDefaults.length)
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
        aCoder.encodeObject(self.medium1.rawValue, forKey: NSCodingKey.Medium1)
        aCoder.encodeObject(self.medium2.rawValue, forKey: NSCodingKey.Medium2)
        aCoder.encodeCGPoint(self.position, forKey: NSCodingKey.Position)
    }

    private func setUp() {
        self.setUpPhysicsProperties()
    }
    
    private func setUpPhysicsProperties() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.frame.size)
        self.physicsBody!.dynamic = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.interface
        self.physicsBody!.contactTestBitMask = PhysicsCategory.photon
        self.physicsBody!.collisionBitMask = PhysicsCategory.none
        self.physicsBody!.usesPreciseCollisionDetection = true
    }
    
    func getDirectionAtPoint(point: CGPoint) -> CGVector {
        return self.direction
    }
    
    func getNewDirectionAfterRefract(directionIn: CGVector, position: CGPoint) -> CGVector {
        let interfaceAngle = self.getDirectionAtPoint(position).angleFromXPlusScalar
        var normalAngle: CGFloat
        if interfaceAngle > CGFloat(M_PI/4) {
            normalAngle = interfaceAngle - CGFloat(M_PI/2)
        } else {
            normalAngle = interfaceAngle + CGFloat(M_PI/2)
        }
        
        
        let angleDifference = interfaceAngle - directionIn.angleFromXPlus
        var mediumIn: XMedium
        var mediumOut: XMedium
        if angleDifference > CGFloat(-M_PI / 2) && angleDifference < CGFloat(M_PI/2) {
            mediumIn = self.medium1
            mediumOut = self.medium2
        } else {
            mediumIn = self.medium2
            mediumOut = self.medium1
        }
        
        
        let inAngle:CGFloat = directionIn.angleFromXPlusScalar - normalAngle
        let outAngle = sin(inAngle) * mediumIn.refractiveIndex / mediumOut.refractiveIndex
        
        let outDirection = CGVector.vectorFromRadius(outAngle)
        return outDirection
    }

}

extension XInterface: XContactable {
    func contactWithPhoton(photon: XPhoton) {
        photon.removeActionForKey(ActionKey.photonActionLinear)
        let direction = self.getNewDirectionAfterRefract(photon.direction, position: photon.position)
        photon.setDirection(direction)
        photon.runAction(SKAction.repeatActionForever(photon.getAction()),
            withKey: ActionKey.photonActionLinear)
    }
}