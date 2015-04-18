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
        self.switchThrowView.center = CGPoint(x: 20 + SwitchDefaults.circleRadius, y: 20)
        
        var throwPath = UIBezierPath()
        throwPath.lineJoinStyle = kCGLineJoinBevel
        throwPath.lineCapStyle = kCGLineCapRound
        throwPath.moveToPoint(CGPoint(x: 20 + 3 * SwitchDefaults.circleRadius, y: 18))
        throwPath.addLineToPoint(CGPoint(x: 62 + 3 * SwitchDefaults.circleRadius, y: -3.5))
        
        var leftPolePath = UIBezierPath()
        
        leftPolePath.lineJoinStyle = kCGLineJoinBevel
        leftPolePath.lineCapStyle = kCGLineCapRound
        
        leftPolePath.moveToPoint(CGPoint(x: -20, y: 20))
        leftPolePath.addLineToPoint(CGPoint(x: 20, y: 20))
        leftPolePath.addArcWithCenter(CGPoint(x: 20 + SwitchDefaults.circleRadius, y: 20), radius: CGFloat(SwitchDefaults.circleRadius), startAngle: CGFloat(-M_PI), endAngle: CGFloat(M_PI), clockwise: true)
        
        var rightPolePath = UIBezierPath()
        
        rightPolePath.lineJoinStyle = kCGLineJoinBevel
        rightPolePath.lineCapStyle = kCGLineCapRound
        rightPolePath.addArcWithCenter(CGPoint(x: 65 + 2 * SwitchDefaults.circleRadius, y: 20), radius: CGFloat(SwitchDefaults.circleRadius), startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
        rightPolePath.addLineToPoint(CGPoint(x: 1024 + 5 * SwitchDefaults.circleRadius, y: 20))

        self.switchThrow.path = throwPath.CGPath
        self.leftPole.path = leftPolePath.CGPath
        self.rightPole.path = rightPolePath.CGPath

        let rect = CGRectMake(0, 0, 1024, 90)
        super.init(frame: rect)
        self.setLayer(self.leftPole)
        self.setLayer(self.rightPole)
        self.setLayer(self.switchThrow)
        
        self.layer.addSublayer(self.leftPole)
        self.layer.addSublayer(self.rightPole)
        
        self.switchThrowView.layer.addSublayer(self.switchThrow)
        self.addSubview(self.switchThrowView)
    }
    
    private func setLayer(layer: CAShapeLayer) {
        layer.strokeColor = UIColor.whiteColor().CGColor
        layer.lineWidth = SwitchDefaults.lineWidth
        layer.shadowOffset = CGSizeZero
        layer.shadowRadius = 2
        layer.shadowColor = layer.strokeColor
        layer.shadowOpacity = 0.5
        layer.fillColor = UIColor.clearColor().CGColor
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
            UIView.animateWithDuration(0.15,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveLinear,
                animations: {
                    self.switchThrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 9))
                }, completion: nil
            )
        }
    }
    
    func setOff() {
        if self.isOn {
            self.isOn = false
            UIView.animateWithDuration(0.15,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveLinear,
                animations: {
                    self.switchThrowView.transform = CGAffineTransformMakeRotation(CGFloat(0))
                }, completion: nil
            )
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
