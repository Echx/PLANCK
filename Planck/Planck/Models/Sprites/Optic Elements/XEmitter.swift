//
//  XEmitter.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import SpriteKit

protocol XEmitterDelegate {
    func emitterDidGenerateNewPhoton(emitter: XEmitter, photon: XPhoton, andAction action: SKAction)
}

class XEmitter: XNode {
    
    var delegate: XEmitterDelegate?
    var appearanceColor: XColor
    var direction: CGVector
    
    init(appearanceColor: XColor, direction: CGVector) {
        self.appearanceColor = appearanceColor
        self.direction = direction
        super.init(
            texture: SKTexture(imageNamed: EmitterDefualts.textureImageName),
            color: EmitterDefualts.textureColor,
            size: CGSizeMake(EmitterDefualts.diameter, EmitterDefualts.diameter)
        );
        self.runAction(SKAction.rotateToAngle(direction.angleFromNorm, duration: 0.0));
    }
    
    func fire() {
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(generateNewPhoton),
                SKAction.waitForDuration(1 / EmitterDefualts.fireFrequency)
                ])
            )
        )
    }
    
    private func generateNewPhoton() {
        let photon = XPhoton(appearanceColor: self.appearanceColor, direction: self.direction)
        photon.position = self.position
        let action = SKAction.repeatActionForever(photon.getAction())
        self.delegate?.emitterDidGenerateNewPhoton(self, photon: photon, andAction: action)
    }
}
