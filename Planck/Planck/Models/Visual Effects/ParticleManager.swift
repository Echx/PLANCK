//
//  ParticleManager.swift
//  Planck
//
//  Created by NULL on 12/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class ParticleManager: NSObject {
    
    struct EmitterDefaults {
        static let emitterBirthRate:Float = 200
        static let emitterLifetime:Float = 0.3
        static let emitterX:CGFloat = 0
        static let emitterY:CGFloat = 0
        static let emitterWidth:CGFloat = 1024
        static let emitterHeight:CGFloat = 768
        static let emitterSize:CGSize = CGSizeMake(10, 10)
        static let emitterXAcceleration:CGFloat = 0.0
        static let emitterYAcceleration:CGFloat = 0.0
        static let emitterSpeed:CGFloat = 2.0
        static let emitterLocation:CGFloat = CGFloat(-M_PI)
        static let emitterVelocityRange:CGFloat = 2.0
        static let emitterEmissionRange:CGFloat = CGFloat(M_PI)
        static let buttonOffset:CGFloat = 1024.0
        static let sparkFile:String = "FireSpark"
    }
    
    class func getParticleLayer() -> CAEmitterLayer{
        let rect = CGRect(x: EmitterDefaults.emitterX, y: EmitterDefaults.emitterY,
            width: EmitterDefaults.emitterWidth, height: EmitterDefaults.emitterHeight)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        
        emitter.emitterShape = kCAEmitterLayerSphere
        emitter.emitterPosition = CGPoint(x: -rect.width / 2, y: -rect.height / 2)
        emitter.emitterSize = EmitterDefaults.emitterSize
        
        let emitterCell = CAEmitterCell()
        emitterCell.scale = 0.03
        emitterCell.contents = UIImage(named: EmitterDefaults.sparkFile)!.CGImage
        emitter.emitterCells = [emitterCell]
        // define params here
        emitterCell.birthRate = EmitterDefaults.emitterBirthRate
        emitterCell.lifetime = EmitterDefaults.emitterLifetime
        
        // define speed
        emitterCell.yAcceleration = EmitterDefaults.emitterYAcceleration
        emitterCell.xAcceleration = EmitterDefaults.emitterXAcceleration
        emitterCell.velocity = EmitterDefaults.emitterSpeed
        emitterCell.emissionLongitude = EmitterDefaults.emitterLocation
        emitterCell.velocityRange = EmitterDefaults.emitterVelocityRange
        emitterCell.emissionRange = EmitterDefaults.emitterEmissionRange
        
        emitterCell.alphaRange = 0.75
        emitterCell.alphaSpeed = -0.15
        emitterCell.lifetimeRange = 1.0
        
        return emitter
    }
    
    class func getParticle(position: CGPoint) -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
        emitterCell.scale = 0.08
        emitterCell.contents = UIImage(named: EmitterDefaults.sparkFile)!.CGImage
        // define params here
        emitterCell.birthRate = EmitterDefaults.emitterBirthRate
        emitterCell.lifetime = EmitterDefaults.emitterLifetime
        
        // define speed
        emitterCell.yAcceleration = EmitterDefaults.emitterYAcceleration
        emitterCell.xAcceleration = EmitterDefaults.emitterXAcceleration
        emitterCell.velocity = EmitterDefaults.emitterSpeed
        emitterCell.emissionLongitude = EmitterDefaults.emitterLocation
        emitterCell.velocityRange = EmitterDefaults.emitterVelocityRange
        emitterCell.emissionRange = EmitterDefaults.emitterEmissionRange
        
        emitterCell.alphaRange = 0.75
        emitterCell.alphaSpeed = -0.15
        emitterCell.lifetimeRange = 1.0
        
        return emitterCell

    }
}
