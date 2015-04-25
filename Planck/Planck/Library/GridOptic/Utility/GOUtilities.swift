//
//  GOUtilities.swift
//  GridOptic
//
//  Created by Lei Mingyu on 01/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOUtilities {
    // ax^2 + bx + c = 0
    class func solveQuadraticEquation(a: CGFloat, b: CGFloat, c: CGFloat) -> (CGFloat?, CGFloat?) {
        let sqrtTerm = b * b - 4 * a * c
        if a == 0 {
            return (nil, nil)
        } else if sqrtTerm < 0 {
            return (nil, nil)
        } else if sqrtTerm == 0 {
            return (-b / 2 / a, nil)
        } else {
            return ((-b + sqrt(sqrtTerm)) / 2 / a, (-b - sqrt(sqrtTerm)) / 2 / a)
        }
    }
    
    class func getDistanceBetweenPoint(a: CGPoint, andPoint b: CGPoint) -> CGFloat {
        let dx = a.x - b.x
        let dy = a.y - b.y
        return sqrt(dx * dx + dy * dy)
    }
    
    class func vectorFromRadius(radius: CGFloat) -> CGVector{
        return CGVectorMake(cos(radius), sin(radius))
    }
    
    class func areaOfTriangle(#first: CGPoint, second: CGPoint, third: CGPoint) -> CGFloat{
        return 0.5 * (first.x * (second.y - third.y) + second.x * (third.y - first.y) + third.x * (first.y - second.y))
    }
}
