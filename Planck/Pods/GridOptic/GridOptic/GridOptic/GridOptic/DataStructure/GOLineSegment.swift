//
//  GOLineSegment.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOLineSegment: GOSegment {
    var length: NSInteger    
    var line: GOLine {
        get {
            return GOLine(anyPoint: CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y)), direction: self.direction)
        }
    }
    
    init(center: CGPoint, length: NSInteger, direction: CGVector) {
        self.length = length;
        super.init()
        self.center = center;
        if direction.dy < 0 {
            self.direction = CGVectorMake(-direction.dx, -direction.dy)
        } else if direction.dy == 0 {
            if direction.dx < 0 {
                self.direction = CGVectorMake(-direction.dx, direction.dy)
            } else {
                self.direction = direction
            }
        } else {
            self.direction = direction
        }
    }
    
    var directionInRadianFromXPlus: CGFloat {
        get {
            return self.direction.angleFromXPlus
        }
    }
    
    var startPoint: CGPoint {
        get {
            let radDirection = self.directionInRadianFromXPlus
            let deltaX = -0.5 * CGFloat(self.length) * cos(radDirection)
            let deltaY = -0.5 * CGFloat(self.length) * sin(radDirection)
            return CGPointMake(CGFloat(center.x) + deltaX, CGFloat(center.y) + deltaY)
        }
    }
    
    var endPoint: CGPoint {
        get {
            let radDirection = self.directionInRadianFromXPlus
            let deltaX = 0.5 * CGFloat(self.length) * cos(radDirection)
            let deltaY = 0.5 * CGFloat(self.length) * sin(radDirection)
            return CGPointMake(CGFloat(center.x) + deltaX, CGFloat(center.y) + deltaY)
        }
    }
    
    override func getIntersectionPoint(ray: GORay) -> CGPoint? {
        if let lineIntersection = GOLine.getIntersection(line1: self.line, line2: ray.line) {
            let start = self.startPoint
            let end = self.endPoint
            
            //get the left and right most x of this line segment
            let leftX = start.x < end.x ? start.x : end.x
            let rightX = start.x < end.x ? end.x : start.x
            
            //if the intersection point is not within [leftX, rightX], then there is no intersection point
            if lineIntersection.x < leftX || lineIntersection.x > rightX {
                return nil
            } else {
                return lineIntersection
            }
        }
        return nil
    }
    
    override func getRefractionRay(#rayIn: GORay, indexIn: CGFloat, indexOut: CGFloat) -> GORay? {
        if let intersectionPoint = self.getIntersectionPoint(rayIn) {
            let l = rayIn.direction.normalised
            let n = self.direction.normalised
            
            let cosTheta1 = CGVector.dot(n, v2: l)
            let cosTheta2 = sqrt(1 - (indexIn / indexOut) * (indexIn / indexOut) * (1 - cosTheta1 * cosTheta1))
            
            let x = (indexIn / indexOut) * l.dx + (indexIn / indexOut * cosTheta1 - cosTheta2) * n.dx
            let y = (indexIn / indexOut) * l.dy + (indexIn / indexOut * cosTheta1 - cosTheta2) * n.dy
            
            return GORay(startPoint: intersectionPoint, direction: CGVectorMake(x, y))
        } else {
            return nil
        }
    }
    
    override func getReflectionRay(#rayIn: GORay) -> GORay? {
        if self.isIntersectedWithRay(rayIn) {
            // get intersection point
            let intersectionPoint = self.getIntersectionPoint(rayIn)!
            // calculate the ray
            let mirrorAngle = self.directionInRadianFromXPlus
            let reflectionAngle = 2 * mirrorAngle + CGFloat(2 * M_PI) - rayIn.direction.angleFromXPlus
            var reflectDirection = GOUtilities.vectorFromRadius(reflectionAngle)

            return GORay(startPoint: intersectionPoint, direction: reflectDirection)
        } else {
            return nil
        }
    }
}
