//
//  OnboardingMaskView.swift
//  Planck
//
//  Created by Wang Jinghan on 19/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class OnboardingMaskView: UIView {
    private struct MethodSelector {
        static let showTapAnimation = Selector("showTapAnimation:")
        static let showDragAnimation = Selector("showDragAnimation:")
        static let viewDidTapped = Selector("viewDidTapped:")
        static let viewDidPanned = Selector("viewDidPanned:")
    }
    
    private let keyForStartPoint = "startPoint"
    private let keyForEndPoint = "endPoint"
    
    private var layers = [String: CALayer]()
    private var maskLayer = CAShapeLayer()
    private var mask = UIView()
    private var isMaskHidden = true
    private var labels = [UILabel]()
    
    private var tapAnimationTimers = [NSTimer]()
    private var dragAnimationTimers = [NSTimer]()
    
    var dashPattern = [8, 8]
    var dashLineWidth: CGFloat = 3
    var dashStrokeColor = UIColor.whiteColor()
    var dashFillColor = UIColor.clearColor()
    var maskColor = UIColor.blackColor()
    var maskOpacity: Float = 0.5
    var startPoint: CGPoint?
    var indicatorColor: UIColor = UIColor.whiteColor()
    var tapFinalRadius: CGFloat = 50
    var tapInitialRadius: CGFloat = 20
    var tapRadiusScale: CGFloat {
        return self.tapFinalRadius / self.tapInitialRadius
    }
    var tapAnimatingDuration: NSTimeInterval = 0.8
    var tapAnimatingDelay: NSTimeInterval = 1.5
    var dragInidicatorRadius: CGFloat = 30
    var dragAnimatingDuration: NSTimeInterval = 1
    var dragAnimatingDelay:NSTimeInterval = 2
    var defaultFadeDuration: NSTimeInterval = 0.5
    var labelFontSize: NSInteger = 22
    
    
    
    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.setUp()
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func clear() {
        self.hideMask(true)
        for (key, layer) in self.layers {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
        
        for label in self.labels {
            label.removeFromSuperview()
        }

        for timer in self.dragAnimationTimers {
            timer.invalidate()
        }
        
        for timer in self.tapAnimationTimers {
            timer.invalidate()
        }
    }
    
    
    //draw a dashed, vain object in the screen according to the given path
    //return the key for the layer, which might be useful when the caller
    //want to retrieve or remove the layer
    func drawDashedTarget(path: UIBezierPath) -> String {
        
        //initialize and set the properties of the shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.lineDashPattern = self.dashPattern
        shapeLayer.lineWidth = self.dashLineWidth
        shapeLayer.strokeColor = self.dashStrokeColor.CGColor
        shapeLayer.fillColor = self.dashFillColor.CGColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineJoin = kCALineJoinBevel
        
        //generate a random key for the new drawn layer
        let randomKey = String.generateRandomString(20)
        
        //insert the layer into self.layer
        self.layers[randomKey] = shapeLayer
        self.layer.addSublayer(shapeLayer)
        
        return randomKey
    }
    
    
    //draw mask, the area between the given path and the screen bounds will be filled
    //with self.maskColor
    func drawMask(path: UIBezierPath?, animated: Bool) {
        if let bezierPath = path {
            let path = UIBezierPath(rect: self.bounds)
            path.appendPath(bezierPath)
            path.usesEvenOddFillRule = true
            self.maskLayer.path = path.CGPath
            self.maskLayer.fillRule = kCAFillRuleEvenOdd
        } else {
            let bezierPath = UIBezierPath(rect: self.bounds)
            self.maskLayer.path = bezierPath.CGPath
            self.maskLayer.fillRule = kCAFillRuleNonZero
        }
        
        self.maskLayer.fillColor = self.maskColor.CGColor
        self.maskLayer.opacity = self.maskOpacity
        self.mask.layer.addSublayer(self.maskLayer)
    }
    
    
    //show the mask
    func showMask(animated: Bool) {
        self.addSubview(self.mask)
        if animated {
            self.fadeView(self.defaultFadeDuration, view: self.mask, fadeIn: true, completion: nil)
        } else {
            self.mask.alpha = 1
        }
        self.isMaskHidden = false
    }
    
    
    //hide the mask
    func hideMask(animated: Bool) {
        if animated {
            self.fadeView(self.defaultFadeDuration, view: self.mask, fadeIn: false, completion: {
                self.mask.removeFromSuperview()
            })
        } else {
            self.mask.removeFromSuperview()
        }
        
        self.isMaskHidden = true
    }
    
    
    //toggle the mask on and off
    func toggleMask(animated: Bool) {
        if self.isMaskHidden {
            self.showMask(animated)
        } else {
            self.hideMask(animated)
        }
    }
    
    //show tap animation at the given point
    // :param: a CGPoint indicating the position
    // :param: a boolean indicating whether the animation should repeat
    func showTapGuidianceAtPoint(point: CGPoint, repeat: Bool) {
        var timer = NSTimer.scheduledTimerWithTimeInterval(
            self.tapAnimatingDelay,
            target: self,
            selector: MethodSelector.showTapAnimation,
            userInfo: NSValue(CGPoint: point),
            repeats: repeat
        )
        
        timer.fire()
        self.tapAnimationTimers.append(timer)
    }
    
    //perform the animation
    // :param: a timer with user info set to the tap position
    private func showTapAnimation(timer: NSTimer) {
        //get the position from userInfo
        let point = (timer.userInfo as NSValue).CGPointValue()
        var containerView = UIView(frame: CGRectMake(0, 0, 2 * self.tapFinalRadius, 2 * self.tapFinalRadius))
        var animatingView = UIView(frame: CGRectMake(0, 0, 2 * self.tapInitialRadius, 2 * self.tapInitialRadius))
        containerView.layer.cornerRadius = self.tapFinalRadius
        containerView.addSubview(animatingView)
        containerView.center = point
        containerView.clipsToBounds = true
        
        animatingView.center = CGPointMake(self.tapFinalRadius, self.tapFinalRadius)
        animatingView.clipsToBounds = true
        
        containerView.alpha = 0
        self.addSubview(containerView)
        self.fadeView(self.defaultFadeDuration, view: containerView, fadeIn: true, completion: {
            var animatingLayer = CAShapeLayer()
            var animatingPath = UIBezierPath(
                arcCenter: CGPointMake(self.tapInitialRadius, self.tapInitialRadius),
                radius: self.tapInitialRadius,
                startAngle: CGFloat(-M_PI),
                endAngle: CGFloat(M_PI),
                clockwise: true)
            animatingLayer.path = animatingPath.CGPath
            animatingLayer.fillColor = self.indicatorColor.CGColor
            animatingView.layer.addSublayer(animatingLayer)
            
            UIView.animateWithDuration(
                self.tapAnimatingDuration,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    var transform = CGAffineTransformIdentity
                    transform = CGAffineTransformScale(transform, self.tapRadiusScale, self.tapRadiusScale)
                    transform = CGAffineTransformTranslate(transform, self.tapFinalRadius, self.tapFinalRadius)
                    animatingView.transform = transform
                    animatingView.frame = containerView.bounds
                    containerView.alpha = 0
                }, completion: {
                    finished in
                    self.fadeView(self.defaultFadeDuration, view: containerView, fadeIn: false, completion: {
                        containerView.removeFromSuperview()
                    })
                }
            )
        })
    }
    
    
    //Show Drag animation from the start point to the end point
    // :param: a point where the animation start
    // :param: a point where the animation end
    // :param: a boolean whether the animatino should repeat
    func showDragGuidianceFromPoint(startPoint: CGPoint, to endPoint: CGPoint, repeat: Bool) {
        var timer = NSTimer.scheduledTimerWithTimeInterval(
            self.dragAnimatingDelay,
            target: self,
            selector: MethodSelector.showDragAnimation,
            userInfo: [keyForStartPoint: NSValue(CGPoint: startPoint), keyForEndPoint: NSValue(CGPoint: endPoint)],
            repeats: repeat
        )
        
        timer.fire()
        self.dragAnimationTimers.append(timer)
    }
    
    //perfrom the drag animation
    // :param: a timer with userInfo set as a Dictionary containing the necessary information
    func showDragAnimation(timer: NSTimer) {
        let points = timer.userInfo as Dictionary<String, AnyObject>
        let startPoint = (points[keyForStartPoint] as NSValue).CGPointValue()
        let endPoint = (points[keyForEndPoint] as NSValue).CGPointValue()
        var animatingView = UIView(frame: CGRectMake(0, 0,
                                    2 * self.dragInidicatorRadius, 2 * self.dragInidicatorRadius))
        
        animatingView.backgroundColor = self.indicatorColor
        animatingView.layer.cornerRadius = self.dragInidicatorRadius
        animatingView.center = startPoint
        animatingView.alpha = 0
        self.addSubview(animatingView)
        self.fadeView(self.defaultFadeDuration, view: animatingView, fadeIn: true, completion: {
            UIView.animateWithDuration(
                self.dragAnimatingDuration,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    animatingView.center = endPoint
                }, completion: {
                    finished in
                    self.fadeView(self.defaultFadeDuration, view: animatingView,
                        fadeIn: false, completion: {
                            animatingView.removeFromSuperview()
                        }
                    )
                }
            )
        })
    }
    
    
    //add a label and set the center of it to the position given
    //the label will be added to self as a subview immediately
    //:param: a string which will be the label's text
    //:param: a CGPoint which will be the label's position
    //returns: the UILabel Object
    func addLabelWithText(text: String, position: CGPoint) -> UILabel{
        var label = UILabel(frame: UIScreen.mainScreen().bounds)
        label.text = text
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: SystemDefault.planckFontBold, size: self.labelFontSize)
        label.center = position
        self.addSubview(label)
        self.labels.append(label)
        return label
    }
    
    
    //perform a fading transition to a view, either fadeIn or fadeOut
    //will execute the completion block when the animation finished
    //:param: a double indicating the animation duration
    //:param: a target view
    //:param: a booleane indicating whether it's fade in or fade out
    //:param: a completion closure(block)
    private func fadeView(duration: NSTimeInterval, view: UIView, fadeIn: Bool, completion: (() -> Void)?) {
        
        UIView.animateWithDuration(
            duration,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                view.alpha = fadeIn ? 1 : 0
            }, completion: {
                finished in
                if let block = completion {
                    block()
                }
            }
        )
    }

    //set up the view properites
    private func setUp() {
        self.setViewProperites()
    }
    
    private func setViewProperites() {
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(self.mask)
        self.mask.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
    }
}
