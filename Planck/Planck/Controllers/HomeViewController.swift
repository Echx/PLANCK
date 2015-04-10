//
//  HomeViewController.swift
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class HomeViewController: XViewController {
    
    // constants for emitter
    private let emitterBirthRate:Float = 20
    private let emitterLifetime:Float = 2
    private let emitterX:CGFloat = 410
    private let emitterY:CGFloat = 270
    private let emitterHeight:CGFloat = 50.0
    private let emitterXAcceleration:CGFloat = 1.0
    private let emitterYAcceleration:CGFloat = 2.0
    private let emitterSpeed:CGFloat = 20.0
    private let emitterLocation:CGFloat = CGFloat(-M_PI)
    private let emitterVelocityRange:CGFloat = 20.0
    private let emitterEmissionRange:CGFloat = CGFloat(M_PI)
    private let buttonOffset:CGFloat = 1024.0
    
    private let sparkFile:String = "FireSpark"
    
    class func getInstance() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = StoryboardIndentifier.Home
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as HomeViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedSlow()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func animatedSlow() {
        let rect = CGRect(x: emitterX, y: emitterY,
            width: 30, height: emitterHeight)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        view.layer.addSublayer(emitter)
        
        emitter.emitterShape = kCAEmitterLayerSphere
        emitter.emitterPosition = CGPoint(x: rect.width / 2, y: rect.height / 2)
        emitter.emitterSize = rect.size
        
        let emitterCell = CAEmitterCell()
        emitterCell.scale = 0.6
        emitterCell.contents = UIImage(named: sparkFile)!.CGImage
        emitter.emitterCells = [emitterCell]
        // define params here
        emitterCell.birthRate = emitterBirthRate
        emitterCell.lifetime = emitterLifetime
        
        // define speed
        emitterCell.yAcceleration = emitterYAcceleration
        emitterCell.xAcceleration = emitterXAcceleration
        emitterCell.velocity = emitterSpeed
        emitterCell.emissionLongitude = emitterLocation
        emitterCell.velocityRange = emitterVelocityRange
        emitterCell.emissionRange = emitterEmissionRange
        
        emitterCell.alphaRange = 0.75
        emitterCell.alphaSpeed = -0.15
        emitterCell.lifetimeRange = 1.0
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
