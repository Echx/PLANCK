//
//  LevelTransitionMaskView.swift
//  Planck
//
//  Created by Wang Jinghan on 12/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

protocol LevelTransitionMaskViewDelegate {
    func viewDidDismiss(view: LevelTransitionMaskView, withButtonClickedAtIndex index: Int)
}

class LevelTransitionMaskView: UIView {
    
    private let badgeViews = [BadgeView]()
    private let buttons = [UIButton]()
    private let hiddenCentersTop = [
        CGPointMake(337, -200),
        CGPointMake(512, -200),
        CGPointMake(687, -200)
    ]
    
    private let hiddenCentersBottom = [
        CGPointMake(337, 968),
        CGPointMake(512, 968),
        CGPointMake(687, 968)
    ]
    
    private let normalCenters = [
        CGPointMake(337, 350),
        CGPointMake(512, 350),
        CGPointMake(687, 350)
    ]
    
    private let buttonImages = [
        UIImage(named: "back"),
        UIImage(named: "replay"),
        UIImage(named: "continue")
    ]
    
    private let imageView = UIImageView(frame: UIScreen.mainScreen().bounds)
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private let audioPlayer = AVAudioPlayer(contentsOfURL: SoundFiles.levelUpSound, error: nil)
    var shouldShowButtons = true
    var delegate: LevelTransitionMaskViewDelegate?
    var autoHide = false
    var animationSpringDamping: CGFloat = 0.5
    var animationInitialSpringVelocity: CGFloat = 10
    var animationDuration = 1.5
    var animationDurationOut: NSTimeInterval {
        get {
            return self.animationDuration * 0.15
        }
    }
    
    var coinCount: Int {
        get {
            return normalCenters.count
        }
    }
    
    let animationDelays = [0.1, 0, 0.05]
    let showButtonUnitDelay = 0.1
    let showButtonDuration = 0.3
    var showButtonDelay: NSTimeInterval = 0.5
    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.imageView.image = UIImage(named: "mainbackground")
        self.addSubview(self.imageView)
        for var i = 0; i < self.coinCount; i++ {
            var badgeView = BadgeView(isOn: true)
            badgeView.center = self.hiddenCentersTop[i]
            self.addSubview(badgeView)
            self.badgeViews.append(badgeView)
            
            var button = UIButton(frame: CGRectMake(0, 0, 150, 150))
            button.center = self.hiddenCentersTop[i]
            button.tag = i
            button.alpha =  0
            button.setImage(self.buttonImages[i], forState: UIControlState.Normal)
            button.addTarget(self, action: "buttonDidClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(button)
            self.addSubview(button)
            self.buttons.append(button)
        }
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hide")
        self.addGestureRecognizer(tapGestureRecognizer!)
        tapGestureRecognizer!.enabled = false
        self.audioPlayer.prepareToPlay()
    }
    
    
    //show n normal and 3-n empty coin
    func show(n: Int) {
        self.alpha = 1
        self.audioPlayer.play()
        self.selectedIndex = self.coinCount - 1
        for var i = 0; i < self.coinCount; i++ {
            self.badgeViews[i].center = self.hiddenCentersTop[i]
            self.buttons[i].center = self.hiddenCentersTop[i]
            self.buttons[i].alpha = 0
            self.badgeViews[i].alpha = 1
            if i < n {
                self.badgeViews[i].setEmpty(false)
            } else {
                self.badgeViews[i].setEmpty(true)
            }
            
            UIView.animateWithDuration(
                self.animationDuration,
                delay: animationDelays[i],
                usingSpringWithDamping: self.animationSpringDamping,
                initialSpringVelocity: self.animationInitialSpringVelocity,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    self.badgeViews[i].center = self.normalCenters[i]
                    self.buttons[i].center = self.normalCenters[i]
                },
                completion: {
                    finished in
                    self.tapGestureRecognizer!.enabled = true
                    if self.shouldShowButtons {
                        let timer = NSTimer.scheduledTimerWithTimeInterval(
                            self.showButtonDelay,
                            target: self,
                            selector: Selector("showButtons"),
                            userInfo: nil,
                            repeats: false)
                    }
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
                    self.badgeViews[i].center = self.hiddenCentersBottom[i]
                    self.buttons[i].center = self.hiddenCentersBottom[i]
                },
                completion: {
                    finished in
                    self.animationComplete()
                })
        }
    }
    
    func showButtons() {
        for var i = 0; i < self.coinCount; i++ {
            UIView.animateWithDuration(
                self.showButtonDuration,
                delay: Double(i) * self.showButtonUnitDelay,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.buttons[i].alpha = 1
                    self.badgeViews[i].alpha = 0
                },
                completion: nil)
        }
    }
    
    var selectedIndex = 2;
    func buttonDidClicked(sender: UIButton) {
        self.selectedIndex = sender.tag
        self.hide()
    }
    
    private var animationCount = 0
    private func animationComplete() {
        self.animationCount++
        if self.animationCount == self.coinCount {
            UIView.animateWithDuration(0.3, animations: {
                    self.alpha = 0
                }, completion: {
                    finished in
                    self.removeFromSuperview()
                    self.animationCount = 0
                    self.delegate?.viewDidDismiss(self, withButtonClickedAtIndex: self.selectedIndex)
                })
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
