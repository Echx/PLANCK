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
        if direction.dy < 0 || (direction.dx == -1 && direction.dy == 0){
            self.direction = CGVectorMake(-direction.dx, -direction.dy)
        } else {
            self.direction = direction
        }

        super.init(
            texture: nil,
            color: MirrorDefaults.textureColor,
            size: MirrorDefaults.flatMirrorSize
        );
        
        self.setUp()
    }
    
    override func getNewDirectionAfterReflect(directionIn: CGVector) -> CGVector {
        var mirrorAngle = self.direction.angleFromXPlus
        var inAngle = directionIn.angleFromXPlus
        var outAngle = 2 * self.direction.angleFromXPlus - directionIn.angleFromXPlus
        
        var vector = CGVector.vectorFromRadius(outAngle)
        if (inAngle - mirrorAngle) * (outAngle - mirrorAngle) < 0 {
            vector = CGVector(dx: -vector.dx, dy: -vector.dy)
        }
        
        if (directionIn.dx < 0) {
            vector = CGVector(dx: -vector.dx, dy: -vector.dy)
        }
        
        return vector
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