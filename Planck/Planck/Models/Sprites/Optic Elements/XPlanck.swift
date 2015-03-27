//
//  XPlanck.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import SpriteKit

class XPlanck: XInsrtument, NSCoding {
    private var colorNoteMapping = Dictionary<XColor, XNote>()
    init() {
        super.init(
            texture: nil,
            color: PlanckDefaults.textureColor,
            size: PlanckDefaults.planckSize
        );
        
        self.setUp()
    }
    
    init(mapping: Array<(XColor, XNote)>) {
        for colorNotePair in mapping {
            self.colorNoteMapping[colorNotePair.0] = colorNotePair.1
        }
        super.init(
            texture: SKTexture(imageNamed: PlanckDefaults.textureImageName),
            color: PlanckDefaults.textureColor,
            size: PlanckDefaults.planckSize
        );
        
        self.setUp()
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.position = aDecoder.decodeCGPointForKey(NSCodingKey.Position)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeCGPoint(self.position, forKey: NSCodingKey.Position)
    }
    
    
    private func setUp() {
        self.color = self.colorNoteMapping.keys.array[0].displayColor
        self.colorBlendFactor = 1
        self.texture = SKTexture(imageNamed: self.colorNoteMapping.values.array[0].getImageFileName())
        self.setUpPhysicsProperties()
    }
    
    private func setUpPhysicsProperties() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: PlanckDefaults.planckPhisicsRadius)
        self.physicsBody!.dynamic = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.planck
        self.physicsBody!.contactTestBitMask = PhysicsCategory.photon
        self.physicsBody!.collisionBitMask = PhysicsCategory.none
        self.physicsBody!.usesPreciseCollisionDetection = true
    }
    
    internal func checkPhoton(photon: XPhoton) {
        let photonColor = photon.appearanceColor
        if contains(self.colorNoteMapping.keys, photonColor) {
            self.runAction(SKAction.playSoundFileNamed(self.colorNoteMapping[photonColor]!.getAudioFileName(), waitForCompletion: false))
        }
    }
}

extension XPlanck: XContactable {
    func contactWithPhoton(photon: XPhoton) {
        self.checkPhoton(photon)
        photon.removeFromParent()
    }
}