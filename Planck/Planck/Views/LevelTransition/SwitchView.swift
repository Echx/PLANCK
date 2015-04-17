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
        throwPath.moveToPoint(CGPoint(x: 0, y: 0))
        throwPath.addLineToPoint(CGPoint(x: 50, y: 0))
        
        var polePath = UIBezierPath()
        
        polePath.lineJoinStyle = kCGLineJoinBevel
        polePath.lineCapStyle = kCGLineCapRound
        polePath.moveToPoint(CGPoint(x: 0, y: 0))
        polePath.addLineToPoint(CGPoint(x: 50, y: 0))
        polePath.addArcWithCenter(CGPoint(x: 50, y: 0), radius: CGFloat(10), startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        var flippedPolePath = polePath.copy() as UIBezierPath
        flippedPolePath.applyTransform(CGAffineTransformMakeScale(-1.0, -1.0))

        self.switchThrow.path = throwPath.CGPath
        self.leftPole.path = polePath.CGPath
        self.rightPole.path = flippedPolePath.CGPath

        let rect = CGRectMake(0, 0, 100, 90)
        super.init(frame: rect)
        
        self.layer.addSublayer(self.leftPole)
//        self.layer.addSublayer(self.switchThrow)
//        self.layer.addSublayer(self.rightPole)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
