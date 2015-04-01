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
}