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
    
    let lineWidth = CGFloat(3.0) // to be refactored
    let circleRadius = CGFloat(6.0) // to be refactored
    
    override init() {
        self.switchThrow.strokeColor = UIColor.whiteColor().CGColor
        self.switchThrow.lineWidth = lineWidth
        
        self.leftPole.strokeColor = UIColor.whiteColor().CGColor
        self.leftPole.lineWidth = lineWidth
        
        self.rightPole.strokeColor = UIColor.whiteColor().CGColor
        self.rightPole.lineWidth = lineWidth
        
        var throwPath = UIBezierPath()

        throwPath.lineJoinStyle = kCGLineJoinBevel
        throwPath.lineCapStyle = kCGLineCapRound
        throwPath.moveToPoint(CGPoint(x: 20 + 2 * circleRadius, y: 20))
        throwPath.addLineToPoint(CGPoint(x: 60 + 2 * circleRadius, y: 0))
        
        var leftPolePath = UIBezierPath()
        
        leftPolePath.lineJoinStyle = kCGLineJoinBevel
        leftPolePath.lineCapStyle = kCGLineCapRound
        leftPolePath.moveToPoint(CGPoint(x: 0, y: 20))
        leftPolePath.addLineToPoint(CGPoint(x: 20, y: 20))
        leftPolePath.addArcWithCenter(CGPoint(x: 20 + circleRadius, y: 20), radius: CGFloat(circleRadius), startAngle: CGFloat(-M_PI), endAngle: CGFloat(M_PI), clockwise: true)
        
        var rightPolePath = UIBezierPath()
        
        rightPolePath.lineJoinStyle = kCGLineJoinBevel
        rightPolePath.lineCapStyle = kCGLineCapRound
        rightPolePath.addArcWithCenter(CGPoint(x: 65 + 2 * circleRadius, y: 20), radius: CGFloat(circleRadius), startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
        rightPolePath.addLineToPoint(CGPoint(x: 75 + 4 * circleRadius, y: 20))

        self.switchThrow.path = throwPath.CGPath
        self.leftPole.path = leftPolePath.CGPath
        self.rightPole.path = rightPolePath.CGPath

        let rect = CGRectMake(0, 0, 100, 90)
        super.init(frame: rect)
        
        self.layer.addSublayer(self.leftPole)
        self.layer.addSublayer(self.switchThrow)
        self.layer.addSublayer(self.rightPole)
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
            
            let rotateAnimation = CABasicAnimation(keyPath: "tranform.rotation")
            rotateAnimation.fromValue = 0.0;
            rotateAnimation.toValue = M_PI;
            rotateAnimation.duration = CFTimeInterval(3.0);
            rotateAnimation.repeatCount = 1.0
            rotateAnimation.fillMode = kCAFillModeForwards
            rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            self.switchThrow.addAnimation(rotateAnimation, forKey: "tranform.rotation")

        }
    }
    
    func setOff() {
        self.isOn = false
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
