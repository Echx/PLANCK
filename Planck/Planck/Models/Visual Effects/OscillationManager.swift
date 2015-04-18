//
//  OscillationManager.swift
//  Planck
//
//  Created by Wang Jinghan on 12/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class OscillationManager: NSObject {
    class func oscillateView(view: UIView, direction: CGVector) {
        
        let scale: CGFloat = 1.5
        let duration: NSTimeInterval = 0.05
        
        let movement = direction.normalize().scaleTo(scale)
        let center = view.center
        let newCenter = CGPointMake(center.x + movement.dx, center.y + movement.dy)
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            view.center = newCenter
            }, completion: {
                finished in
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    view.center = center
                    }, completion: nil)
        })
    }

}
