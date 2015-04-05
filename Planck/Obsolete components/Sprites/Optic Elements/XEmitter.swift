//
//  XEmitter.swift
//  Planck
//
//  Created by Lei Mingyu on 10/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//
import Foundation
import UIKit
import SpriteKit

protocol XEmitterDelegate {
    func emitterDidGenerateNewPhoton(emitter: XEmitter, photon: XPhoton, andAction action: SKAction)
}

class XEmitter: XInsrtument, NSCoding {
    
    var delegate: XEmitterDelegate?
    var appearanceColor: XColor
    var photon: XPhoton?
    var canFire = true
    
    init(appearanceColor: XColor, direction: CGVector) {
        self.appearanceColor = appearanceColor
        super.init(
            texture: SKTexture(imageNamed: EmitterDefualts.textureImageName),
            color: EmitterDefualts.textureColor,
            size: CGSizeMake(EmitterDefualts.diameter, EmitterDefualts.diameter)
        );
        self.direction = direction
        self.setUp()
    }

    override func setDirection(angleFromYPlus: CGFloat) {
        super.setDirection(angleFromYPlus)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let color = aDecoder.decodeObjectForKey(NSCodingKey.ApperanceColor)! as XColor
        let direction = aDecoder.decodeCGVectorForKey(NSCodingKey.Direction)
        self.init(appearanceColor: color, direction: direction)
        self.position = aDecoder.decodeCGPointForKey(NSCodingKey.Position)
        self.canFire = aDecoder.decodeBoolForKey(NSCodingKey.CanFire)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.appearanceColor, forKey: NSCodingKey.ApperanceColor)
        aCoder.encodeCGVector(self.direction, forKey: NSCodingKey.Direction)
        aCoder.encodeCGPoint(self.position, forKey: NSCodingKey.Position)
        aCoder.encodeBool(self.canFire, forKey: NSCodingKey.CanFire)
    }
    
    private func setUp() {
        self.color = self.appearanceColor.displayColor
        self.colorBlendFactor = 1
    }
    
    func fire() {
        runAction(SKAction.runBlock(generateOpticalPath))
//        runAction(SKAction.repeatActionForever(
//            SKAction.sequence([
//                SKAction.runBlock(generateNewPhoton),
//                SKAction.waitForDuration(1 / EmitterDefualts.fireFrequency)
//                ])
//            )
//        )
    }
    
    private func generateOpticalPath() {
        self.photon = XPhoton(appearanceColor: self.appearanceColor, direction: self.direction)
        self.photon!.position = self.position
        CGPathMoveToPoint(self.photon!.opticalPath, nil, self.photon!.position.x,
            self.photon!.position.y)
        let action = SKAction.repeatActionForever(self.photon!.getAction())
        self.delegate?.emitterDidGenerateNewPhoton(self, photon: self.photon!, andAction: action)
    }
}
