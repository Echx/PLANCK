//
//  OscillationManager.swift
//  Planck
//
//  Created by Wang Jinghan on 12/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

//This class manages the touch feedback oscillation in the project
class OscillationManager: NSObject {
    
    //default parameters for the oscillation
    struct OscillateDefaults {
        static let scale: CGFloat = 1.5
        static let duration: NSTimeInterval = 0.05
        static let delay: NSTimeInterval = 0
        static let springDamping: CGFloat = 0.6
        static let springInitialVelocity: CGFloat = 20
    }
    
    //This method will oscillate the view passed in, with the specified initial direction.
    class func oscillateView(view: UIView, direction: CGVector) {
        
        //calculate the animation offset
        let movement = direction.normalize().scaleTo(OscillateDefaults.scale)
        let center = view.center
        let newCenter = CGPointMake(center.x + movement.dx, center.y + movement.dy)
        
        //animate the view
        UIView.animateWithDuration(
            OscillateDefaults.duration,
            delay: OscillateDefaults.delay,
            usingSpringWithDamping: OscillateDefaults.springDamping,
            initialSpringVelocity: OscillateDefaults.springInitialVelocity,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                view.center = newCenter
            }, completion: {
                finished in
                
                //animate the view back
                UIView.animateWithDuration(
                    OscillateDefaults.duration,
                    delay: OscillateDefaults.delay,
                    usingSpringWithDamping: OscillateDefaults.springDamping,
                    initialSpringVelocity: OscillateDefaults.springInitialVelocity,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        view.center = center
                    }, completion: nil
                )
            }
        )
    }
}
