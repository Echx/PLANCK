//
//  SwitchView.swift
//  Planck
//
//  Created by Lei Mingyu on 17/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class SwitchView: UIView {
    var isOn = false
    
    let switchThrow = CAShapeLayer()
    let leftPole = CAShapeLayer()
    let rightPole = CAShapeLayer()
    
    let switchThrowView = UIView(frame: CGRect(x: 0, y: 0, width: 67, height: 40))
    
    override init() {
        self.leftPole.fillColor = UIColor.clearColor().CGColor
        self.rightPole.fillColor = UIColor.clearColor().CGColor
        
        self.switchThrow.strokeColor = UIColor.whiteColor().CGColor
        self.switchThrow.lineWidth = SwitchDefaults.lineWidth
        
        self.leftPole.strokeColor = UIColor.whiteColor().CGColor
        self.leftPole.lineWidth = SwitchDefaults.lineWidth
        
        self.rightPole.strokeColor = UIColor.whiteColor().CGColor
        self.rightPole.lineWidth = SwitchDefaults.lineWidth
        
        self.switchThrowView.center = CGPoint(x: 20 + 2 * SwitchDefaults.circleRadius, y: 20)
        
        var throwPath = UIBezierPath()
        throwPath.lineJoinStyle = kCGLineJoinBevel
        throwPath.lineCapStyle = kCGLineCapRound
        throwPath.moveToPoint(CGPoint(x: 20 + 2 * SwitchDefaults.circleRadius, y: 20)) // center of rotation
        throwPath.addLineToPoint(CGPoint(x: 60 + 2 * SwitchDefaults.circleRadius, y: 0))
        
        var leftPolePath = UIBezierPath()
        
        leftPolePath.lineJoinStyle = kCGLineJoinBevel
        leftPolePath.lineCapStyle = kCGLineCapRound
        
        leftPolePath.moveToPoint(CGPoint(x: 0, y: 20))
        leftPolePath.addLineToPoint(CGPoint(x: 20, y: 20))
        leftPolePath.addArcWithCenter(CGPoint(x: 20 + SwitchDefaults.circleRadius, y: 20), radius: CGFloat(SwitchDefaults.circleRadius), startAngle: CGFloat(-M_PI), endAngle: CGFloat(M_PI), clockwise: true)
        
        var rightPolePath = UIBezierPath()
        
        rightPolePath.lineJoinStyle = kCGLineJoinBevel
        rightPolePath.lineCapStyle = kCGLineCapRound
        rightPolePath.addArcWithCenter(CGPoint(x: 65 + 2 * SwitchDefaults.circleRadius, y: 20), radius: CGFloat(SwitchDefaults.circleRadius), startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
        rightPolePath.addLineToPoint(CGPoint(x: 75 + 5 * SwitchDefaults.circleRadius, y: 20))

        self.switchThrow.path = throwPath.CGPath
        self.leftPole.path = leftPolePath.CGPath
        self.rightPole.path = rightPolePath.CGPath

        let rect = CGRectMake(0, 0, 100, 90)
        super.init(frame: rect)
    
        self.layer.addSublayer(self.leftPole)
        self.layer.addSublayer(self.rightPole)
        
        self.switchThrowView.layer.addSublayer(self.switchThrow)
        self.addSubview(self.switchThrowView)
    }
    
    func toggle() {
        if self.isOn {
            self.setOff()
        } else {
            self.setOn()
        }
    }
    
    func setOn() {
        if !self.isOn {
            self.isOn = true
            UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.switchThrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 9))
            }, completion: nil)
        }
    }
    
    func setOff() {
        if self.isOn {
            self.isOn = false
            UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.switchThrowView.transform = CGAffineTransformMakeRotation(CGFloat(0))
                }, completion: nil)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
