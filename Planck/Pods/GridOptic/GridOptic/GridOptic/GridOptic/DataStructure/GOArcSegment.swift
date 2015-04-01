//
//  GOArcSegment.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOArcSegment: GOSegment {
    var radius: CGFloat
    var radian: CGFloat
    
    init(center: CGPoint, radius: CGFloat, radian: CGFloat, normalDirection: CGVector) {
        self.radius = radius
        self.radian = radian
        super.init()
        self.center = center
        self.normalDirection = normalDirection
    }
    
    var scaledStartVector: CGVector {
        get {
            let startVector = CGVector(
                dx: normalDirection.dx * cos(-radian) - normalDirection.dy * sin(-radian),
                dy: normalDirection.dx * sin(-radian) + normalDirection.dy * cos(-radian)
            )
            return startVector.scaleTo(self.radius)
        }
    }
    
    var scaledEndVector: CGVector {
        let endVector = CGVector(
            dx: normalDirection.dx * cos(radian) - normalDirection.dy * sin(radian),
            dy: normalDirection.dx * sin(radian) + normalDirection.dy * cos(radian)
        )
        return endVector.scaleTo(self.radius)
    }
    
    var startPoint: CGPoint {
        get {
            return CGPoint(
                x: CGFloat(center.x) + self.scaledStartVector.dx,
                y: CGFloat(center.y) + self.scaledStartVector.dy
            )
        }
    }
    
    var endPoint: CGPoint {
        get {
            return CGPoint(
                x: CGFloat(center.x) + self.scaledEndVector.dx,
                y: CGFloat(center.y) + self.scaledEndVector.dy
            )
        }
    }
    
    var startRadian: CGFloat {
        get {
            return atan(self.scaledStartVector.dy / self.scaledStartVector.dx)
        }
    }
    
    var endRadian: CGFloat {
        get {
            return atan(self.scaledEndVector.dy / self.scaledEndVector.dx)
        }
    }
    
    
    override func getIntersectionPoint(ray: GORay) -> CGPoint? {
        let lineOfRay = ray.line
        let k = lineOfRay.slope
        let c = lineOfRay.yIntercept
        let r1 = CGFloat(self.center.x)
        let r2 = CGFloat(self.center.y)
        let r = self.radius
        let termA = 1 + k * k
        let termB = 2 * (c - r1 - r2)
        let termC = r1 * r1 + (r2 - c) * (r2 - c) - r * r
        
        let xs = GOUtilities.solveQuadraticEquation(termA, b: termB, c: termC)
        
        if xs.0 == nil {
            return nil
        } else if xs.1 == nil {
            // 相切
            if let y = ray.getY(x: xs.0!) {
                return CGPoint(x: xs.0!, y: y)
            } else {
                return nil
            }
        } else {
            if let y0 = ray.getY(x: xs.0!) {
                if let y1 = ray.getY(x: xs.1!) {
                    if GOUtilities.getDistanceBetweenPoints(ray.startPoint, b: CGPoint(x: xs.0!, y: y0)) >
                        GOUtilities.getDistanceBetweenPoints(ray.startPoint, b: CGPoint(x: xs.1!, y: y1)) {
                        return CGPoint(x: xs.1!, y: y1)
                    } else {
                        return CGPoint(x: xs.0!, y: y0)
                    }
                } else {
                    return CGPoint(x: xs.0!, y: y0)
                }
            } else {
                if let y1 = ray.getY(x: xs.1!) {
                    return CGPoint(x: xs.1!, y: y1)
                } else {
                    return nil
                }
            }
        }
    }
    
}
