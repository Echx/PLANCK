//
//  SwitchView.swift
//  Planck
//
//  Created by Lei Mingyu on 17/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class SwitchView: UIView {
    let switchThrow = CAShapeLayer()
    let leftPole = CAShapeLayer()
    let rightPole = CAShapeLayer()
    
    override init() {
        self.switchThrow.strokeColor = UIColor.whiteColor().CGColor
        self.switchThrow.lineWidth = 5.0
        
        self.leftPole.strokeColor = UIColor.whiteColor().CGColor
        self.leftPole.lineWidth = 5.0
        
        self.rightPole.strokeColor = UIColor.whiteColor().CGColor
        self.rightPole.lineWidth = 5.0
        
        var throwPath = UIBezierPath()

        throwPath.lineJoinStyle = kCGLineJoinBevel
        throwPath.lineCapStyle = kCGLineCapRound
        throwPath.moveToPoint(CGPoint(x: 40, y: 20))
        throwPath.addLineToPoint(CGPoint(x: 90, y: 0))
        
        var leftPolePath = UIBezierPath()
        
        leftPolePath.lineJoinStyle = kCGLineJoinBevel
        leftPolePath.lineCapStyle = kCGLineCapRound
        leftPolePath.moveToPoint(CGPoint(x: 0, y: 20))
        leftPolePath.addLineToPoint(CGPoint(x: 20, y: 20))
        leftPolePath.addArcWithCenter(CGPoint(x: 30, y: 20), radius: CGFloat(10), startAngle: CGFloat(-M_PI), endAngle: CGFloat(M_PI), clockwise: true)
        
        var rightPolePath = UIBezierPath()
        
        rightPolePath.lineJoinStyle = kCGLineJoinBevel
        rightPolePath.lineCapStyle = kCGLineCapRound
        rightPolePath.addArcWithCenter(CGPoint(x: 105, y: 20), radius: CGFloat(10), startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
        rightPolePath.addLineToPoint(CGPoint(x: 135, y: 20))

        
        

        self.switchThrow.path = throwPath.CGPath
        self.leftPole.path = leftPolePath.CGPath
        self.rightPole.path = rightPolePath.CGPath

        let rect = CGRectMake(0, 0, 100, 90)
        super.init(frame: rect)
        
        self.layer.addSublayer(self.leftPole)
        self.layer.addSublayer(self.switchThrow)
        self.layer.addSublayer(self.rightPole)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
