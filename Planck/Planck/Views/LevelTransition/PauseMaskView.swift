//
//  PauseMaskView.swift
//  Planck
//
//  Created by NULL on 13/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

protocol PauseMaskViewDelegate {
    func buttonDidClickedAtIndex(index: Int)
}

class PauseMaskView: UIView {

    
    var animationSpringDamping: CGFloat = 0.5
    var animationInitialSpringVelocity: CGFloat = 10
    var animationDurationIn = 1.0
    var animationDurationOut = 0.3
    var delegate: PauseMaskViewDelegate?
    var buttonCount: Int {
        get {
            return normalCenters.count
        }
    }
    
    
    private let buttons = [UIButton]()
    private let hiddenCenters = [
        CGPointMake(337, -200),
        CGPointMake(512, -200),
        CGPointMake(687, -200)
    ]
    
    private let normalCenters = [
        CGPointMake(337, 384),
        CGPointMake(512, 384),
        CGPointMake(687, 384)
    ]
    
    private let buttonImages = [
        UIImage(named: "back"),
        UIImage(named: "replay"),
        UIImage(named: "continue")
    ]
    
    private let animationDelays = [0.1, 0, 0.05]
    private let imageView = UIImageView(frame: UIScreen.mainScreen().bounds)

    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.imageView.image = UIImage(named: "mainbackground")
        self.imageView.alpha = 0.8
        self.addSubview(self.imageView)
        for var i = 0; i < self.buttonCount; i++ {
            var button = UIButton(frame: CGRectMake(0, 0, 150, 150))
            button.center = self.hiddenCenters[i]
            button.tag = i
            button.setImage(self.buttonImages[i], forState: UIControlState.Normal)
            button.addTarget(self, action: "buttonDidClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(button)
            self.buttons.append(button)
        }
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func show() {
        for var i = 0; i < self.buttonCount; i++ {
            self.buttons[i].center = self.hiddenCenters[i]
            
            UIView.animateWithDuration(
                self.animationDurationIn,
                delay: animationDelays[i],
                usingSpringWithDamping: self.animationSpringDamping,
                initialSpringVelocity: self.animationInitialSpringVelocity,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    self.buttons[i].center = self.normalCenters[i]
                },
                completion: nil)
        }
    }
    
    func hide() {
        self.animationCount = 0
        for var i = 0; i < self.buttonCount; i++ {
            UIView.animateWithDuration(
                self.animationDurationOut,
                delay: animationDelays[i],
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    self.buttons[i].center = self.hiddenCenters[i]
                },
                completion: {
                    finished in
                    self.animationComplete()
            })
        }
    }
    
    func buttonDidClicked(sender: UIButton) {
        self.delegate?.buttonDidClickedAtIndex(sender.tag)
    }
    
    
    private var animationCount = 0
    private func animationComplete() {
        self.animationCount++
        if self.animationCount == self.buttonCount {
            self.removeFromSuperview()
        }
    }



}
