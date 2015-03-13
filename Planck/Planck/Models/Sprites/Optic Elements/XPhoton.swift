//
//  XPhoton.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import SpriteKit

class XPhoton: XNode {
    var illuminance: CGFloat
    var appearanceColor: XColor
    var direction: CGVector
    
    override init() {
        self.illuminance = PhotonDefaults.illuminance
        self.appearanceColor = PhotonDefaults.appearanceColor
        self.direction = PhotonDefaults.direction
        
        //designated initializer, only this one can be used in subclasses of SKNode
        super.init(
            texture: SKTexture(imageNamed: PhotonDefaults.textureImageName),
            color: PhotonDefaults.textureColor,
            size: CGSizeMake(PhotonDefaults.diameter, PhotonDefaults.diameter)
        )
        self.setUp()
    }
    
    init(appearanceColor: XColor, direction: CGVector) {
        self.illuminance = PhotonDefaults.illuminance
        self.appearanceColor = appearanceColor
        self.direction = direction
        
        //designated initializer, only this one can be used in subclasses of SKNode
        super.init(
            texture: nil,
            color: appearanceColor.displayColor,
            size: CGSizeMake(PhotonDefaults.diameter, PhotonDefaults.diameter)
        );
        
        self.setUp()
    }
    
    
    init(illuminance: CGFloat, color: XColor, direction: CGVector) {
        self.illuminance = illuminance
        self.appearanceColor = color
        self.direction = direction
        
        //designated initializer, only this one can be used in subclasses of SKNode
        super.init(
            texture: SKTexture(imageNamed: PhotonDefaults.textureImageName),
            color: PhotonDefaults.textureColor,
            size: CGSizeMake(PhotonDefaults.diameter, PhotonDefaults.diameter)
        );
        
        self.setUp()
    }
    
    private func setUp() {
        //name is useful during enumeration (like tag of UIViews)
        self.name = NodeName.xPhoton
        self.runAction(SKAction.rotateToAngle(direction.angleFromYPlus, duration: 0.0));
        self.setUpPhotonPhysicsProperty()
    }
    
    
    //return an action calculated from self.direction
    //move in self.direction with speed of light in vacuum
    func getAction() -> SKAction {
        var action = SKAction.moveBy(self.direction, duration: Double(self.direction.length / Constant.lightSpeedBase));
        return action
    }
    
    
    //move in self.direction with speed of light in the provided medium
    func getAction(#medium: XMedium) -> SKAction {
        var action = SKAction.moveBy(self.direction, duration: Double(self.direction.length / getSpeedInMedium(medium)));
        return action
    }
    
    
    //methods used for updating direction
    //useful for optic instruments to modify the state of the node
    func setDirection(newDirection: CGVector) {
        self.direction = newDirection
    }
    
    
    //get the light speed in the provide medium
    private func getSpeedInMedium(medium: XMedium) -> CGFloat {
        return Constant.lightSpeedBase / medium.getRefractiveIndex()
    }
    
    
    private func setUpPhotonPhysicsProperty() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(PhotonDefaults.diameter, PhotonDefaults.diameter))
        self.physicsBody!.dynamic = true
        
        //collision detection use
        self.physicsBody!.categoryBitMask = PhysicsCategory.photon
        self.physicsBody!.contactTestBitMask = PhysicsCategory.flatMirror
        self.physicsBody!.collisionBitMask = PhysicsCategory.none
        self.physicsBody!.usesPreciseCollisionDetection = true
        
        //No speed loss when reflected
        self.physicsBody!.restitution = 1.0 //max bounceness
        self.physicsBody!.linearDamping = 0.0 //not reduce linear velocity over time
        self.physicsBody!.friction = 0.0 //no friction
    }
}

