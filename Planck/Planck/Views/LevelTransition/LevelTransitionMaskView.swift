//
//  LevelTransitionMaskView.swift
//  Planck
//
//  Created by Wang Jinghan on 12/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

/// LevelTransitionMaskView will notify its delegate which button was clicked
/// and present itself when it get dismissed
protocol LevelTransitionMaskViewDelegate {
    func viewDidDismiss(view: LevelTransitionMaskView, withButtonClickedAtIndex index: Int)
}

/// This is a view to be shown after user successfully finish a level
/// It will present the badge the user achieved, then display three button options
class LevelTransitionMaskView: UIView {
    // define some constant
    private struct MethodSelector {
        static let buttonDidClicked = Selector("buttonDidClicked:")
        static let showButtons = Selector("showButtons")
        static let hide = Selector("hide")
    }
    
    private let congratulationLabelFrame = CGRect(x: 0, y: 600, width: UIScreen.mainScreen().bounds.width, height: 50)
    private let congratulationText = "Congratulation! You have unlocked the next section! (*´╰╯`๓)♬"
    private var congratulationLabel = UILabel()
    
    private let buttonFrame = CGRectMake(0, 0, 150, 150)
    
    private var badgeViews = [BadgeView]()
    private var buttons = [UIButton]()
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
        UIImage(named: XImageName.backImage),
        UIImage(named: XImageName.replayImage),
        UIImage(named: XImageName.nextImage),
        UIImage(named: XImageName.nextSectionImage)
    ]
    
    private let audioPlayer = AVAudioPlayer(contentsOfURL: SoundFiles.levelUpSound, error: nil)
    
    // count the number of animation executed
    private var animationCount = 0
    // the index of the button selected
    private var selectedIndex = 2
    
    
    //public properties which user can modify outside the class
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
    var animationDelays = [0.1, 0, 0.05]
    var showButtonUnitDelay = 0.1
    var showButtonDuration = 0.3
    var showButtonDelay: NSTimeInterval = 0.5
    
    var coinCount: Int {
        get {
            return normalCenters.count
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.mainScreen().bounds)
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        blurView.frame = self.bounds
        self.addSubview(blurView)
        self.congratulationLabel = UILabel(frame: congratulationLabelFrame)
        self.congratulationLabel.text = congratulationText
        self.congratulationLabel.textAlignment = NSTextAlignment.Center
        self.congratulationLabel.textColor = UIColor.whiteColor()
        
        for var i = 0; i < self.coinCount; i++ {
            var badgeView = BadgeView(isOn: true)
            badgeView.center = self.hiddenCentersTop[i]
            self.addSubview(badgeView)
            self.badgeViews.append(badgeView)
            
            var button = UIButton(frame: buttonFrame)
            button.center = self.hiddenCentersTop[i]
            button.tag = i
            button.alpha = 0
            button.setImage(self.buttonImages[i], forState: UIControlState.Normal)
            button.addTarget(self, action: MethodSelector.buttonDidClicked, forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(button)
            self.addSubview(button)
            self.buttons.append(button)
        }
        
        self.buttons[2].setImage(self.buttonImages[3], forState: UIControlState.Highlighted)
        self.audioPlayer.prepareToPlay()
    }
    
    /**
    Show n filled and 3 - n empty badge
    
    :param: n the number of fulfill badge
    :param: isSectionFinished a boolean indicating whether the section is finished
    
    */
    func show(n: Int, isSectionFinished: Bool) {
        // REQUIRES: 0 <= n <= 3
        self.alpha = 1
        self.audioPlayer.play()
        self.selectedIndex = self.coinCount - 1
        if isSectionFinished {
            self.buttons[2].highlighted = true
            self.addSubview(self.congratulationLabel)
        } else {
            self.buttons[2].highlighted = false
            self.congratulationLabel.removeFromSuperview()
        }

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
                    if self.shouldShowButtons {
                        let timer = NSTimer.scheduledTimerWithTimeInterval(
                            self.showButtonDelay,
                            target: self,
                            selector: MethodSelector.showButtons,
                            userInfo: nil,
                            repeats: false)
                    } else {
                        let timer = NSTimer.scheduledTimerWithTimeInterval(
                            self.showButtonDelay,
                            target: self,
                            selector: MethodSelector.hide,
                            userInfo: nil,
                            repeats: false)
                    }
                })
        }
    }
    
    /**
    Hide the trainisition view
    */
    func hide() {
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
    
    /**
    Display buttons
    */
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
    
    /**
    A method to record which button has been clicked
    */
    func buttonDidClicked(sender: UIButton) {
        self.selectedIndex = sender.tag
        self.hide()
    }
    
    /**
    This method is used to finish displaying badge and show the button options
    */
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
        fatalError("init(coder:) has not been implemented")
    }
}
