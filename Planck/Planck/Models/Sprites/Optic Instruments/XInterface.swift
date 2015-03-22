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
    
    private func setUp() {
        self.setUpPhysicsProperties()
    }
    
    private func setUpPhysicsProperties() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.frame.size)
        self.physicsBody!.dynamic = false
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