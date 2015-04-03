//
//  CGPoint+GOUtilities.swift
//  GridOptic
//
//  Created by Wang Jinghan on 01/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func getPointAfterRotation(#about: CGPoint, toAngle: CGFloat) -> CGPoint{
        let distance = self.getDistanceToPoint(about)
        let newX = round(distance * cos(toAngle) * Constant.angleCalculationPrecision) / Constant.angleCalculationPrecision
        let newY = round(distance * sin(toAngle) * Constant.angleCalculationPrecision) / Constant.angleCalculationPrecision
        return CGPointMake(about.x + newX, about.y + newY)
    }
    
    func getPointAfterRotation(#about: CGPoint, byAngle: CGFloat) -> CGPoint{
        let distance = self.getDistanceToPoint(about)
        let currentAngle = CGVectorMake(self.x - about.x, self.y - about.y).angleFromXPlus
        let toAngle = currentAngle + byAngle
        let newX = round(distance * cos(toAngle) * Constant.angleCalculationPrecision) / Constant.angleCalculationPrecision
        let newY = round(distance * sin(toAngle) * Constant.angleCalculationPrecision) / Constant.angleCalculationPrecision
        return CGPointMake(about.x + newX, about.y + newY)
    }
    
    func getDistanceToPoint(point: CGPoint) -> CGFloat{
        return sqrt((self.x - point.x) * (self.x - point.x) +
                    (self.y - point.y) * (self.y - point.y))
    }
    
    func getRadiusFrom(point: CGPoint) -> CGFloat {
        // swift can handle 90 deg case
        if self.x < point.x {
            return atan((self.y - point.y) / (self.x - point.x)) + CGFloat(M_PI)
        } else {
            return atan((self.y - point.y) / (self.x - point.x))
        }
    }
    
    func isNearEnough(point: CGPoint) -> Bool {
        return (self.x - point.x).abs < Constant.overallPrecision &&
            (self.y - point.y).abs < Constant.overallPrecision
    }
}