//
//  OnboardingMaskView.swift
//  Planck
//
//  Created by Wang Jinghan on 19/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

protocol OnboardingMaskViewDelegate {
    func viewDidTapped(view: OnboardingMaskView, sender: UITapGestureRecognizer)
    func viewDidPanned(view: OnboardingMaskView, sender: UIPanGestureRecognizer)
}

class OnboardingMaskView: UIView {
    private var layers = [String: CALayer]()
    private var maskLayer = CAShapeLayer()
    private var mask = UIView()
    private var isMaskHidden = true
    private var labels = [UILabel]()
    
    private var tapAnimationTimer: NSTimer?
    private var dragAnimationTimer: NSTimer?
    
    var delegate: OnboardingMaskViewDelegate?
    
    var dashPattern = [8, 8]
    var dashLineWidth: CGFloat = 3
    var dashStrokeColor = UIColor.whiteColor()
    var dashFillColor = UIColor.clearColor()
    
    
    var maskColor = UIColor.blackColor()
    var maskOpacity: Float = 0.5
    
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
    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.setUp()
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        var path = UIBezierPath(rect: CGRectMake(312, 334, 400, 100))
        self.drawDashedTarget(path)
        self.drawMask(path, animated: true)
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
        
        self.dragAnimationTimer?.invalidate()
        self.tapAnimationTimer?.invalidate()
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
    
    func showMask(animated: Bool) {
        self.addSubview(self.mask)
        if animated {
            self.fadeView(self.defaultFadeDuration, view: self.mask, fadeIn: true, completion: nil)
        } else {
            self.mask.alpha = 1
        }
        self.isMaskHidden = false
    }
    
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
    
    func toggleMask(animated: Bool) {
        println("toggle")
        if self.isMaskHidden {
            self.showMask(animated)
        } else {
            self.hideMask(animated)
        }
    }
    
    func showTapGuidianceAtPoint(point: CGPoint, repeat: Bool) {
        self.tapAnimationTimer = NSTimer.scheduledTimerWithTimeInterval(
            self.tapAnimatingDelay,
            target: self,
            selector: "showTapAnimation:",
            userInfo: NSValue(CGPoint: point),
            repeats: repeat
        )
        
        self.tapAnimationTimer?.fire()
    }
    
    func showTapAnimation(timer: NSTimer) {
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
    
    func showDragGuidianceFromPoint(startPoint: CGPoint, to endPoint: CGPoint, repeat: Bool) {
        self.dragAnimationTimer = NSTimer.scheduledTimerWithTimeInterval(
            self.dragAnimatingDelay,
            target: self,
            selector: "showDragAnimation:",
            userInfo: ["startPoint": NSValue(CGPoint: startPoint), "endPoint": NSValue(CGPoint: endPoint)],
            repeats: repeat
        )
        
        self.dragAnimationTimer?.fire()
    }
    
    func showDragAnimation(timer: NSTimer) {
        let points = timer.userInfo as Dictionary<String, AnyObject>
        let startPoint = (points["startPoint"] as NSValue).CGPointValue()
        let endPoint = (points["endPoint"] as NSValue).CGPointValue()
        var animatingView = UIView(frame: CGRectMake(0, 0, 2 * self.dragInidicatorRadius, 2 * self.dragInidicatorRadius))
        animatingView.backgroundColor = self.indicatorColor
        animatingView.layer.cornerRadius = self.dragInidicatorRadius
        animatingView.center = startPoint
        animatingView.alpha = 0
        self.addSubview(animatingView)
        self.fadeView(0.5, view: animatingView, fadeIn: true, completion: {
            UIView.animateWithDuration(
                self.dragAnimatingDuration,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    animatingView.center = endPoint
                }, completion: {
                    finished in
                    self.fadeView(self.defaultFadeDuration, view: animatingView, fadeIn: false, completion: {
                        animatingView.removeFromSuperview()
                        }
                    )
                }
            )
        })
    }
    
    func addLabelWithText(text: String, position: CGPoint) -> UILabel{
        var label = UILabel(frame: UIScreen.mainScreen().bounds);
        label.text = text
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: "Akagi-SemiBold", size: 22)
        label.center = position
        self.addSubview(label)
        self.labels.append(label)
        return label
    }
    
    func viewDidTapped(sender: UITapGestureRecognizer) {
//        println(sender.numberOfTouches())
//        if sender.numberOfTouches() == 2 {
//            self.toggleMask(true)
//        } else {
//            self.showTapGuidianceAtPoint(sender.locationInView(self), repeat: true)
//        }
//        
        self.delegate?.viewDidTapped(self, sender: sender)
    }
    
    var startPoint: CGPoint?
    func viewDidPanned(sender: UIPanGestureRecognizer) {
//        if sender.state == UIGestureRecognizerState.Began {
//            startPoint = sender.locationInView(self)
//        } else if sender.state == UIGestureRecognizerState.Ended {
//            let endPoint = sender.locationInView(self)
//            self.showDragGuidianceFromPoint(startPoint!, to: endPoint, repeat: true)
//        }
        self.delegate?.viewDidPanned(self, sender: sender)
    }
    
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

    private func setUp() {
        self.setViewProperites()
        self.setRecognizers()
    }
    
    private func setRecognizers() {
        for i in 1..<5 {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewDidTapped:")
            tapGestureRecognizer.numberOfTouchesRequired = i
            self.addGestureRecognizer(tapGestureRecognizer)
        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "viewDidPanned:")
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setViewProperites() {
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(self.mask)
        self.mask.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
    }
}
