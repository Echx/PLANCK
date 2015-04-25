//
//  GOLine.swift
//  GridOptic
//
//  Created by Wang Jinghan on 31/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOLine: NSObject {
    var anyPoint: CGPoint
    // angle should be in [0, PI)
    var direction: CGVector
    var slope: CGFloat {
        get {
            if self.direction.dx.abs < GOConstant.overallPrecision {
                return CGFloat.max
            }
            
            return self.direction.dy / self.direction.dx
        }
    }
    
    // y Intercept for mathematical calculation
    var yIntercept: CGFloat? {
        get {
            return self.getY(x: 0)
        }
    }
    
    init(anyPoint: CGPoint, direction: CGVector) {
        self.anyPoint = anyPoint
        if direction.dy < 0 || (direction.dy == 0 && direction.dx < 0){
            self.direction = CGVectorMake(-direction.dx, -direction.dy)
        } else {
            self.direction = direction
        }
    }
    
    //give the corresponding y of a given x, nil if not defined
    func getY(#x: CGFloat) -> CGFloat? {
        if self.slope == CGFloat.max {
            if x == self.anyPoint.x {
                return anyPoint.y
            } else {
                return nil
            }
        } else if self.slope == 0 {
            return self.anyPoint.y
        }
        
        let deltaX = x - self.anyPoint.x
        let deltaY = deltaX * self.slope
        return self.anyPoint.y + deltaY
    }
    
    //give the corresponding x of a given y, nil if not defined
    func getX(#y: CGFloat) -> CGFloat? {
        if self.slope == 0 {
            if y == self.anyPoint.y {
                return anyPoint.x
            } else {
                return nil
            }
        } else if self.slope == CGFloat.max {
            return anyPoint.x
        }
        
        let deltaY = y - self.anyPoint.y
        let deltaX = deltaY / self.slope
        return self.anyPoint.x + deltaX
    }
    
    class func getIntersection(#line1: GOLine, line2: GOLine) -> CGPoint? {
        if abs(line1.slope - line2.slope) < GOConstant.overallPrecision {
            return nil
        } else if line1.slope == CGFloat.max {
            var x = line1.anyPoint.x
            var y = line2.getY(x: x)!

            return CGPointMake(x, y)
        } else if line2.slope == CGFloat.max {
            var x = line2.anyPoint.x
            var y = line1.getY(x: x)!

            return CGPointMake(x, y)
        } else {
            var x = (line2.anyPoint.y - line1.anyPoint.y +
                line1.slope * line1.anyPoint.x - line2.slope * line2.anyPoint.x) /
                (line1.slope - line2.slope)

            if let y = line1.getY(x: x) {
                return CGPointMake(x, y)
            } else {
                return nil
            }
        }
    }
}
