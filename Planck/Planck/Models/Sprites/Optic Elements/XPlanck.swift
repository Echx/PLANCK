//
//  XPlanck.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import SpriteKit

class XPlanck: XInsrtument {
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
            texture: nil,
            color: PlanckDefaults.textureColor,
            size: PlanckDefaults.planckSize
        );
        
        self.setUp()
    }
    
    
    private func setUp() {
        self.setUpPhysicsProperties()
    }
    
    private func setUpPhysicsProperties() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: PlanckDefaults.planckRadius)
        self.physicsBody!.dynamic = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.planck
        self.physicsBody!.contactTestBitMask = PhysicsCategory.photon
        self.physicsBody!.collisionBitMask = PhysicsCategory.none
        self.physicsBody!.usesPreciseCollisionDetection = true
    }
    
    internal func checkPhoton(photon: XPhoton) {
        let photonColor = photon.appearanceColor
        if contains(self.colorNoteMapping.keys, photonColor) {
            println("HA")
        }
    }
}

extension XPlanck: XContactable {
    func contactWithPhoton(photon: XPhoton) {
        self.checkPhoton(photon)
        photon.removeFromParent()
    }
}