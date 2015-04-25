//
//  PauseMaskView.swift
//  Planck
//
//  Created by Wang Jinghan on 13/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

/// The delegate will be notified when user click a button in pause view
protocol PauseMaskViewDelegate {
    func buttonDidClickedAtIndex(index: Int)
}

/// This view will be presented when user pause the game
class PauseMaskView: UIView {
    private struct MethodSelector {
        static let buttonDidClicked = Selector("buttonDidClicked:")
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
        UIImage(named: XImageName.backImage),
        UIImage(named: XImageName.replayImage),
        UIImage(named: XImageName.nextImage)
    ]
    
    private let animationDelays = [0.1, 0, 0.05]
    private let imageView = UIImageView(frame: UIScreen.mainScreen().bounds)
    // The animation that has been executed
    private var animationCount = 0
    
    var animationSpringDamping: CGFloat = 0.5
    var animationInitialSpringVelocity: CGFloat = 10
    var animationDurationIn = 1.0
    var animationDurationOut = 0.3
    var buttonCount: Int {
        get {
            return normalCenters.count
        }
    }
    
    /// The delegate of this view
    var delegate: PauseMaskViewDelegate?
    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        blurView.frame = self.bounds
        self.addSubview(blurView)
        
        for var i = 0; i < self.buttonCount; i++ {
            var button = UIButton(frame: CGRectMake(0, 0, 150, 150))
            button.center = self.hiddenCenters[i]
            button.tag = i
            button.setImage(self.buttonImages[i], forState: UIControlState.Normal)
            button.addTarget(self, action: MethodSelector.buttonDidClicked, forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(button)
            self.buttons.append(button)
        }
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    /**
    Show the pause mask view
    */
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
    
    /**
    Hide the pause mask view
    */
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
    
    /**
    Called when the animation is complete
    */
    private func animationComplete() {
        self.animationCount++
        if self.animationCount == self.buttonCount {
            self.removeFromSuperview()
        }
    }



}
