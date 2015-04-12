//
//  LevelTransitionMastView.swift
//  Planck
//
//  Created by NULL on 12/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class LevelTransitionMastView: UIView {
    
    let coinViews = [CoinView]()
    let hiddenCentersTop = [
        CGPointMake(337, -200),
        CGPointMake(512, -200),
        CGPointMake(687, -200)
    ]
    
    let hiddenCentersBottom = [
        CGPointMake(337, 968),
        CGPointMake(512, 968),
        CGPointMake(687, 968)
    ]
    
    let normalCenters = [
        CGPointMake(337, 350),
        CGPointMake(512, 350),
        CGPointMake(687, 350)
    ]
    
    var animationSpringDamping: CGFloat = 0.5
    var animationInitialSpringVelocity: CGFloat = 10
    var animationDuration = 1.5
    var animationDurationOut: NSTimeInterval {
        get {
            return self.animationDuration * 0.7
        }
    }
    
    var coinCount: Int {
        get {
            return normalCenters.count
        }
    }
    
    let animationDelays = [0.1, 0, 0.05]
    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        for var i = 0; i < self.coinCount; i++ {
            var coinView = CoinView(isOn: true)
            self.addSubview(coinView)
            coinView.center = self.hiddenCentersTop[i]
            self.coinViews.append(coinView)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hide")
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    //show n normal and 3-n empty coin
    func show(n: Int) {
        for var i = 0; i < self.coinCount; i++ {
            self.coinViews[i].center = self.hiddenCentersTop[i]
            
            if i < n {
                self.coinViews[i].setEmpty(false)
            } else {
                self.coinViews[i].setEmpty(true)
            }
            
            UIView.animateWithDuration(
                self.animationDuration,
                delay: animationDelays[i],
                usingSpringWithDamping: self.animationSpringDamping,
                initialSpringVelocity: self.animationInitialSpringVelocity,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    self.coinViews[i].center = self.normalCenters[i]
                },
                completion: nil)
        }
    }
    
    func hide() {
        for var i = 0; i < self.coinCount; i++ {
            UIView.animateWithDuration(
                self.animationDurationOut,
                delay: animationDelays[i],
                usingSpringWithDamping: self.animationSpringDamping,
                initialSpringVelocity: 0,
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    self.coinViews[i].center = self.hiddenCentersBottom[i]
                },
                completion: nil)
        }
        NSTimer.scheduledTimerWithTimeInterval(2.1, target: self, selector: "removeFromSuperview", userInfo: nil, repeats: false)
    }
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
