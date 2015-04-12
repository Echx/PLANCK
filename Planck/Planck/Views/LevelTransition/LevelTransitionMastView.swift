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
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    var animationSpringDamping: CGFloat = 0.5
    var animationInitialSpringVelocity: CGFloat = 10
    var animationDuration = 1.5
    var animationDurationOut: NSTimeInterval {
        get {
            return self.animationDuration * 0.3
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
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hide")
        self.addGestureRecognizer(tapGestureRecognizer!)
        tapGestureRecognizer!.enabled = false
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
                completion: {
                    finished in
                    self.tapGestureRecognizer!.enabled = true
                })
        }
    }
    
    func hide() {
        self.tapGestureRecognizer?.enabled = false
        self.animationCount = 0
        for var i = 0; i < self.coinCount; i++ {
            UIView.animateWithDuration(
                self.animationDurationOut,
                delay: animationDelays[i],
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    self.coinViews[i].center = self.hiddenCentersBottom[i]
                },
                completion: {
                    finished in
                    self.animationComplete()
                })
        }
    }
    
    private var animationCount = 0
    private func animationComplete() {
        self.animationCount++
        if self.animationCount == self.coinCount {
            self.removeFromSuperview()
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
