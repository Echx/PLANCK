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
        static let emitterBirthRate:Float = 19
        static let emitterLifetime:Float = 1
        static let emitterX:CGFloat = 0
        static let emitterY:CGFloat = 0
        static let emitterWidth:CGFloat = 1024
        static let emitterHeight:CGFloat = 768
        static let emitterSize:CGSize = CGSizeMake(5, 5)
        static let emitterXAcceleration:CGFloat = 0.0
        static let emitterYAcceleration:CGFloat = 0.0
        static let emitterSpeed:CGFloat = 0.0
        static let emitterLocation:CGFloat = CGFloat(-M_PI)
        static let emitterVelocityRange:CGFloat = 0
        static let emitterEmissionRange:CGFloat = CGFloat(M_PI)
        static let buttonOffset:CGFloat = 1024.0
//        static let sparkFile:String = "FireSpark"
        static let sparkFile:String = "spark-circle"
    }
    
    class func getHomeBackgroundParticles() -> CAEmitterLayer{
        var rect = UIScreen.mainScreen().bounds
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        
        emitter.emitterShape = kCAEmitterLayerPoints
        emitter.emitterPosition = CGPoint(x: rect.width / 2, y: rect.height / 2)
        emitter.emitterSize = UIScreen.mainScreen().bounds.size
        emitter.renderMode = kCAEmitterLayerAdditive
        
        let emitterCell = CAEmitterCell()
        emitterCell.scale = 0.05
        emitterCell.contents = UIImage(named: EmitterDefaults.sparkFile)!.CGImage
        emitter.emitterCells = [emitterCell]
        // define params here
        emitterCell.birthRate = 50
        emitterCell.lifetime = 16
        emitterCell.spin = 0
        emitterCell.spinRange = CGFloat(M_PI * 2)
        
        // define speed
        emitterCell.yAcceleration = 100
        emitterCell.xAcceleration = 100
        emitterCell.velocity = 100
        emitterCell.velocityRange = 50
        emitterCell.emissionRange = CGFloat(M_PI)
        
        emitterCell.alphaRange = 2
        emitterCell.alphaSpeed = -2
        emitterCell.lifetimeRange = 1
        3.0
        
        return emitter
    }
    
    class func getParticleLayer() -> CAEmitterLayer {
        let rect = CGRect(x: EmitterDefaults.emitterX, y: EmitterDefaults.emitterY,
            width: EmitterDefaults.emitterWidth, height: EmitterDefaults.emitterHeight)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        
        emitter.emitterShape = kCAEmitterLayerPoints
        emitter.emitterPosition = CGPoint(x: -rect.width / 2, y: -rect.height / 2)
        emitter.emitterSize = EmitterDefaults.emitterSize
        emitter.renderMode = kCAEmitterLayerAdditive
        
        let emitterCell = CAEmitterCell()
        emitterCell.scale = 0.03
        emitterCell.contents = UIImage(named: EmitterDefaults.sparkFile)!.CGImage
        emitter.emitterCells = [emitterCell]
        // define params here
        emitterCell.birthRate = EmitterDefaults.emitterBirthRate
        emitterCell.lifetime = EmitterDefaults.emitterLifetime
        emitterCell.spin = 0
        emitterCell.spinRange = CGFloat(M_PI * 2)
        
        // define speed
        emitterCell.yAcceleration = EmitterDefaults.emitterYAcceleration
        emitterCell.xAcceleration = EmitterDefaults.emitterXAcceleration
        emitterCell.velocity = EmitterDefaults.emitterSpeed
        emitterCell.emissionLongitude = EmitterDefaults.emitterLocation
        emitterCell.velocityRange = EmitterDefaults.emitterVelocityRange
        emitterCell.emissionRange = EmitterDefaults.emitterEmissionRange
        
        emitterCell.alphaRange = 2
        emitterCell.alphaSpeed = -2
        emitterCell.lifetimeRange = 1.0
        
        return emitter
    }
}
