//
//  SwitchView.swift
//  Planck
//
//  Created by Lei Mingyu on 17/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

/// This is the switch view appear at the bottom of the game view
/// when the player tap the switch, the status of the switch will be toggle,
/// if the switch is changed to on, all the emitter present on screen will 
/// shoot the light beam
class SwitchView: UIView {
    var isOn = false
    
    /// this three layers comprise the poles and throw
    let switchThrow = CAShapeLayer()
    let leftPole = CAShapeLayer()
    let rightPole = CAShapeLayer()
    
    let switchThrowView = UIView(frame: SwitchDefaults.switchViewThrowFrame)
    
    override init(frame: CGRect) {
        super.init(frame: SwitchDefaults.switchFrame)

        self.switchThrowView.center = SwitchDefaults.switchThrowCenter
        
        var throwPath = UIBezierPath()
        throwPath.lineJoinStyle = kCGLineJoinBevel
        throwPath.lineCapStyle = kCGLineCapRound
        throwPath.moveToPoint(SwitchDefaults.switchThrowStartPoint)
        throwPath.addLineToPoint(SwitchDefaults.switchThrowEndPoint)
        
        var leftPolePath = UIBezierPath()
        
        leftPolePath.lineJoinStyle = kCGLineJoinBevel
        leftPolePath.lineCapStyle = kCGLineCapRound
        
        leftPolePath.moveToPoint(SwitchDefaults.switchLeftPoleStartPoint)
        leftPolePath.addLineToPoint(SwitchDefaults.switchLeftPoleEndPoint)
        leftPolePath.addArcWithCenter(SwitchDefaults.switchLeftPoleCircleStartPoint,
            radius: CGFloat(SwitchDefaults.circleRadius),
            startAngle: CGFloat(-M_PI),
            endAngle: CGFloat(M_PI),
            clockwise: true)
        
        var rightPolePath = UIBezierPath()
        
        rightPolePath.lineJoinStyle = kCGLineJoinBevel
        rightPolePath.lineCapStyle = kCGLineCapRound
        rightPolePath.addArcWithCenter(SwitchDefaults.switchRightPoleCircleStartPoint,
            radius: CGFloat(SwitchDefaults.circleRadius),
            startAngle: CGFloat(0),
            endAngle: CGFloat(2 * M_PI),
            clockwise: true)
        rightPolePath.addLineToPoint(SwitchDefaults.switchRightPoleEndPoint)

        self.switchThrow.path = throwPath.CGPath
        self.leftPole.path = leftPolePath.CGPath
        self.rightPole.path = rightPolePath.CGPath

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
            UIView.animateWithDuration(SwitchDefaults.animationDuration,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveLinear,
                animations: {
                    self.switchThrowView.transform = CGAffineTransformMakeRotation(
                        SwitchDefaults.switchRotateDegree)
                }, completion: nil
            )
        }
    }
    
    func setOff() {
        if self.isOn {
            self.isOn = false
            UIView.animateWithDuration(SwitchDefaults.animationDuration,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveLinear,
                animations: {
                    self.switchThrowView.transform = CGAffineTransformMakeRotation(
                        CGFloat(0))
                }, completion: nil
            )
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
