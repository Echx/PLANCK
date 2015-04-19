//
//  GOLineSegment.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOLineSegment: GOSegment {
    var length: CGFloat
    var line: GOLine {
        get {
            return GOLine(anyPoint: CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y)), direction: self.direction)
        }
    }
    override var bezierPath: UIBezierPath {
        get {
            var path = UIBezierPath()
            path.moveToPoint(self.startPoint)
            path.addLineToPoint(self.endPoint)
//            path.closePath()
            return path
        }
    }
    
    init(center: CGPoint, length: CGFloat, direction: CGVector) {
        self.length = length;
        super.init()
        self.center = center;
        self.direction = direction
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let willRefract = aDecoder.decodeBoolForKey(GOCodingKey.segment_willRef)
        let willReflect = aDecoder.decodeBoolForKey(GOCodingKey.segment_willRel)
        
        let center = aDecoder.decodeCGPointForKey(GOCodingKey.segment_center)
        let tag = aDecoder.decodeObjectForKey(GOCodingKey.segment_tag) as NSInteger
        
        let parent = aDecoder.decodeObjectForKey(GOCodingKey.segment_parent) as String
        
        let length = aDecoder.decodeObjectForKey(GOCodingKey.segment_length) as CGFloat
        
        let direction = aDecoder.decodeCGVectorForKey(GOCodingKey.segment_direction)
        
        self.init(center: center, length: length, direction: direction)
        self.willReflect = willReflect
        self.willRefract = willRefract

        self.tag = tag
        self.parent = parent
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(willRefract, forKey: GOCodingKey.segment_willRef)
        aCoder.encodeBool(willReflect, forKey: GOCodingKey.segment_willRel)
        aCoder.encodeCGPoint(center, forKey: GOCodingKey.segment_center)
        aCoder.encodeCGVector(direction, forKey: GOCodingKey.segment_direction)
        aCoder.encodeObject(tag, forKey: GOCodingKey.segment_tag)
        aCoder.encodeObject(parent, forKey: GOCodingKey.segment_parent)
        
        aCoder.encodeObject(length, forKey: GOCodingKey.segment_length)
    }
    
    var directionInRadianFromXPlus: CGFloat {
        get {
            return self.direction.angleFromXPlus
        }
    }
    
    override var startPoint: CGPoint {
        get {
            let radDirection = self.directionInRadianFromXPlus
            let deltaX = -0.5 * self.length * cos(radDirection)
            let deltaY = -0.5 * self.length * sin(radDirection)
            return CGPointMake(center.x + deltaX, center.y + deltaY)
        }
    }
    
    override var endPoint: CGPoint {
        get {
            let radDirection = self.directionInRadianFromXPlus
            let deltaX = 0.5 * self.length * cos(radDirection)
            let deltaY = 0.5 * self.length * sin(radDirection)
            return CGPointMake(center.x + deltaX, center.y + deltaY)
        }
    }
    
    override func getIntersectionPoint(ray: GORay) -> CGPoint? {
        if let lineIntersection = GOLine.getIntersection(line1: self.line, line2: ray.line) {
            let start = self.startPoint
            let end = self.endPoint
            
            //get the left and right most x of this line segment
            let leftX = start.x < end.x ? start.x : end.x
            let rightX = start.x < end.x ? end.x : start.x
            let topY = start.y < end.y ? start.y : end.y
            let bottomY = start.y < end.y ? end.y : start.y
            
            //if the intersection point is not within [leftX, rightX], then there is no intersection point
            if abs(lineIntersection.x - ray.startPoint.x) < GOConstant.overallPrecision &&
                abs(lineIntersection.y - ray.startPoint.y) < GOConstant.overallPrecision {
                return nil
            } else if lineIntersection.x < leftX ||
                lineIntersection.x > rightX ||
                lineIntersection.y < topY ||
                lineIntersection.y > bottomY {
                return nil
            } else if lineIntersection.x == ray.startPoint.x { // check vertical intersection
                if lineIntersection.y < ray.startPoint.y {
                    // the intersection is above ray start point
                    if ray.direction.dy < 0 {
                        // if ray is towards top, this is the point
                        return lineIntersection
                    } else {
                        // if ray is towards bottom, cannot reach this point
                        return nil
                    }
                } else {
                    // the intersection is below ray start point
                    if ray.direction.dy < 0 {
                        // if ray is towards top, cannot reach this point
                        return nil
                    } else {
                        // if ray is towards bottom, cannot reach this point
                        return lineIntersection
                    }
                }
            } else if ray.direction.dx > 0 && lineIntersection.x <= ray.startPoint.x {
                return nil
            } else if ray.direction.dx < 0 && lineIntersection.x >= ray.startPoint.x {
                return nil
            } else {
                return lineIntersection
            }
        }
        return nil
    }
    
    override func getRefractionRay(#rayIn: GORay, indexIn: CGFloat, indexOut: CGFloat) -> (GORay, Bool)? {
        if let intersectionPoint = self.getIntersectionPoint(rayIn) {
            let l = rayIn.direction.normalised
            var n: CGVector
            if CGVector.dot(rayIn.direction, v2: self.normalDirection) < 0 {
                n = self.normalDirection.normalised
            } else {
                n = CGVectorMake(-self.normalDirection.dx, -self.normalDirection.dy).normalised
            }
            
            let cosTheta1 = -CGVector.dot(n, v2: l)
            
            // Total reflection
            if 1.0 - (indexIn / indexOut) * (indexIn / indexOut) * (1 - cosTheta1 * cosTheta1) < 0 {
                if let reflectionRay = self.getReflectionRay(rayIn: rayIn) {
                    return (reflectionRay, true)
                } else {
                    return nil
                }
            }
            
            let cosTheta2 = sqrt(1 - (indexIn / indexOut) * (indexIn / indexOut) * (1 - cosTheta1 * cosTheta1))
            
            let x = (indexIn / indexOut) * l.dx + (indexIn / indexOut * cosTheta1 - cosTheta2) * n.dx
            let y = (indexIn / indexOut) * l.dy + (indexIn / indexOut * cosTheta1 - cosTheta2) * n.dy
            
            return (GORay(startPoint: intersectionPoint, direction: CGVectorMake(x, y)), false)
        } else {
            return nil
        }
    }
    
    override func getReflectionRay(#rayIn: GORay) -> GORay? {
        if let intersectionPoint = self.getIntersectionPoint(rayIn) {
            let l = rayIn.direction.normalised
            var n: CGVector
            if CGVector.dot(rayIn.direction, v2: self.normalDirection) < 0 {
                n = self.normalDirection.normalised
            } else {
                n = CGVectorMake(-self.normalDirection.dx, -self.normalDirection.dy).normalised
            }
            let cosTheta1 = -CGVector.dot(n, v2: l)
            
            let intermidiateX = 2 * cosTheta1 * n.dx
            let intermidiateY = 2 * cosTheta1 * n.dy
            
            var reflectDirection = CGVector(dx: l.dx + intermidiateX,
                                            dy: l.dy + intermidiateY)
            
            return GORay(startPoint: intersectionPoint, direction: reflectDirection)
        } else {
            return nil
        }
    }
}
