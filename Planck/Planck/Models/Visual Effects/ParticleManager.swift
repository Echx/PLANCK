//
//  ParticleManager.swift
//  Planck
//
//  Created by Wang Jinghan on 12/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

//This class manages the behaviors of all the particle effects in the project
class ParticleManager: NSObject {

    //Particle effects specifics for light ray
    struct ParticleDefaults {
        static let emitterLayerFrame = UIScreen.mainScreen().bounds
        static let emitterLayerEmitterSize = CGSizeMake(5, 5)
        static let emitterLayerEmitterShape = kCAEmitterLayerPoints
        static let emitterLayerPosition = CGPoint(x: -emitterLayerFrame.width / 2, y: -emitterLayerFrame.height / 2)
        static let emitterLayerRenderMode = kCAEmitterLayerAdditive
        
        static let emitterCellScale: CGFloat = 0.03
        static let emitterCellContent = UIImage(named: "FireSpark")!.CGImage
        static let emitterCellBirthRate: Float = 19
        static let emitterCellLifeTime: Float = 1
        static let emitterCellLifeTimeRange: Float = 1
        static let emitterCellSpin: CGFloat = 0
        static let emitterCellSpinRange: CGFloat = CGFloat(M_PI * 2)
        static let emitterCellXAcceleration: CGFloat = 0
        static let emitterCellYAcceleration: CGFloat = 0
        static let emitterCellVelocity: CGFloat = 0
        static let emitterCellVelocityRange: CGFloat = 0
        static let emitterCellEmissionRange: CGFloat = CGFloat(M_PI)
        static let emitterCellAlphaRange: Float = 2
        static let emitterCellAlphaSpeed: Float = -2
        static let emitterCellEmissionLongtitude: CGFloat = CGFloat(-M_PI)
    }

    //Particle effects specifics for home view
    struct HomeParticleDefaults {
        static let emitterLayerFrame = UIScreen.mainScreen().bounds
        static let emitterLayerEmitterSize = UIScreen.mainScreen().bounds.size
        static let emitterLayerEmitterShape = kCAEmitterLayerPoints
        static let emitterLayerPosition = CGPoint(x: emitterLayerFrame.width / 2, y: emitterLayerFrame.height / 2)
        static let emitterLayerRenderMode = kCAEmitterLayerAdditive
        
        static let emitterCellScale: CGFloat = 0.05
        static let emitterCellBirthRate: Float = 20
        static let emitterCellLifeTime: Float = 1
        static let emitterCellLifeTimeRange: Float = 1
        static let emitterCellSpin: CGFloat = 0
        static let emitterCellSpinRange: CGFloat = CGFloat(M_PI * 2)
        static let emitterCellXAcceleration: CGFloat = 10
        static let emitterCellYAcceleration: CGFloat = 10
        static let emitterCellVelocity: CGFloat = 40
        static let emitterCellVelocityRange: CGFloat = 30
        static let emitterCellEmissionRange: CGFloat = CGFloat(M_PI) * 0.6
        static let emitterCellAlphaRange: Float = 2
        static let emitterCellAlphaSpeed: Float = -1.7
    }
    
    // :returns: a CAEmitterLayer which represents the particle effects inside a light ray
    class func getParticleLayer() -> CAEmitterLayer {
        let emitterCell = CAEmitterCell()
    
        //register default properties for CAEmitterCell
        emitterCell.scale               = ParticleDefaults.emitterCellScale
        emitterCell.contents            = ParticleDefaults.emitterCellContent
        emitterCell.birthRate           = ParticleDefaults.emitterCellBirthRate
        emitterCell.lifetime            = ParticleDefaults.emitterCellLifeTime
        emitterCell.lifetimeRange       = ParticleDefaults.emitterCellLifeTimeRange
        emitterCell.spin                = ParticleDefaults.emitterCellSpin
        emitterCell.spinRange           = ParticleDefaults.emitterCellSpinRange
        emitterCell.xAcceleration       = ParticleDefaults.emitterCellXAcceleration
        emitterCell.yAcceleration       = ParticleDefaults.emitterCellYAcceleration
        emitterCell.velocity            = ParticleDefaults.emitterCellVelocity
        emitterCell.velocityRange       = ParticleDefaults.emitterCellVelocityRange
        emitterCell.emissionLongitude   = ParticleDefaults.emitterCellEmissionLongtitude
        emitterCell.emissionRange       = ParticleDefaults.emitterCellEmissionRange
        emitterCell.alphaRange          = ParticleDefaults.emitterCellAlphaRange
        emitterCell.alphaSpeed          = ParticleDefaults.emitterCellAlphaSpeed

        
        let emitter = CAEmitterLayer()
        
        //register default properities for CAEmitterLayer
        emitter.frame           = ParticleDefaults.emitterLayerFrame
        emitter.emitterShape    = ParticleDefaults.emitterLayerEmitterShape
        emitter.emitterPosition = ParticleDefaults.emitterLayerPosition
        emitter.emitterSize     = ParticleDefaults.emitterLayerEmitterSize
        emitter.renderMode      = ParticleDefaults.emitterLayerRenderMode
    
        //link the cell and the layer and return
        emitter.emitterCells    = [emitterCell]
        return emitter
    }
    
    
    // :param: the file name of the texture
    // :param: the longtitude of the emitterCell
    // :returns: a CAEmitterLayer which represents the particle effects for home view
    class func getHomeBackgroundParticles(textureFileName: String, longtitude: CGFloat) -> CAEmitterLayer{
        let emitterCell = CAEmitterCell()
        
        //register default properties for CAEmitterCell
        emitterCell.scale           = HomeParticleDefaults.emitterCellScale
        emitterCell.birthRate       = HomeParticleDefaults.emitterCellBirthRate
        emitterCell.lifetime        = HomeParticleDefaults.emitterCellLifeTime
        emitterCell.lifetimeRange   = HomeParticleDefaults.emitterCellLifeTimeRange
        emitterCell.spin            = HomeParticleDefaults.emitterCellSpin
        emitterCell.spinRange       = HomeParticleDefaults.emitterCellSpinRange
        emitterCell.xAcceleration   = HomeParticleDefaults.emitterCellXAcceleration
        emitterCell.yAcceleration   = HomeParticleDefaults.emitterCellYAcceleration
        emitterCell.velocity        = HomeParticleDefaults.emitterCellVelocity
        emitterCell.velocityRange   = HomeParticleDefaults.emitterCellVelocityRange
        emitterCell.emissionRange   = HomeParticleDefaults.emitterCellEmissionRange
        emitterCell.alphaRange      = HomeParticleDefaults.emitterCellAlphaRange
        emitterCell.alphaSpeed      = HomeParticleDefaults.emitterCellAlphaSpeed
        
        //register variable properties for CAEmitterCell
        emitterCell.emissionLongitude = longtitude
        if let image = UIImage(named: textureFileName) {
            emitterCell.contents = image.CGImage
        }

        let emitter = CAEmitterLayer()

        //register default properities for CAEmitterLayer
        emitter.frame               = HomeParticleDefaults.emitterLayerFrame
        emitter.emitterSize         = HomeParticleDefaults.emitterLayerEmitterSize
        emitter.emitterShape        = HomeParticleDefaults.emitterLayerEmitterShape
        emitter.emitterPosition     = HomeParticleDefaults.emitterLayerPosition
        emitter.renderMode          = HomeParticleDefaults.emitterLayerRenderMode
        emitter.seed                = UInt32(random())
        
        //link the cell and the layer and return
        emitter.emitterCells = [emitterCell]
        return emitter
    }
}
