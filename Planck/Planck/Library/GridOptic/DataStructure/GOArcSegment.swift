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
    
    override var bezierPath: UIBezierPath {
        get {
            var path = UIBezierPath()
            path.addArcWithCenter(self.center, radius: self.radius,
                startAngle: self.endRadian, endAngle: self.startRadian, clockwise: false)
            return path
        }
    }
    
    init(center: CGPoint, radius: CGFloat, radian: CGFloat, normalDirection: CGVector) {
        self.radius = radius
        self.radian = radian
        super.init()
        self.normalDirection = normalDirection
        self.center = center
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let radius = aDecoder.decodeObjectForKey(GOCodingKey.segment_radius) as CGFloat
        let radian = aDecoder.decodeObjectForKey(GOCodingKey.segment_radian) as CGFloat
        
        let willRefract = aDecoder.decodeBoolForKey(GOCodingKey.segment_willRef)
        let willReflect = aDecoder.decodeBoolForKey(GOCodingKey.segment_willRel)
        
        let center = aDecoder.decodeCGPointForKey(GOCodingKey.segment_center)
        let tag = aDecoder.decodeObjectForKey(GOCodingKey.segment_tag) as NSInteger
        
        let parent = aDecoder.decodeObjectForKey(GOCodingKey.segment_parent) as String
        
        let direction = aDecoder.decodeCGVectorForKey(GOCodingKey.segment_direction)
        let normalDirection = aDecoder.decodeCGVectorForKey(GOCodingKey.segment_normalDir)
        
        self.init(center: center, radius: radius, radian: radian, normalDirection: normalDirection)
        self.willReflect = willReflect
        self.willRefract = willRefract

        self.tag = tag
        self.parent = parent
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(radius, forKey: GOCodingKey.segment_radius)
        aCoder.encodeObject(radian, forKey: GOCodingKey.segment_radian)
        
        aCoder.encodeBool(willRefract, forKey: GOCodingKey.segment_willRef)
        aCoder.encodeBool(willReflect, forKey: GOCodingKey.segment_willRel)
        aCoder.encodeCGPoint(center, forKey: GOCodingKey.segment_center)

        aCoder.encodeObject(tag, forKey: GOCodingKey.segment_tag)
        aCoder.encodeObject(parent, forKey: GOCodingKey.segment_parent)
        
        aCoder.encodeCGVector(normalDirection, forKey: GOCodingKey.segment_normalDir)
    }
    
    var scaledStartVector: CGVector {
        get {
            let startVector = CGVector(
                dx: normalDirection.dx * cos(-radian / 2) - normalDirection.dy * sin(-radian / 2),
                dy: normalDirection.dx * sin(-radian / 2) + normalDirection.dy * cos(-radian / 2)
            )
            return startVector.scaleTo(self.radius)
        }
    }
    
    var scaledEndVector: CGVector {
        get {
            let endVector = CGVector(
                dx: normalDirection.dx * cos(radian / 2) - normalDirection.dy * sin(radian / 2),
                dy: normalDirection.dx * sin(radian / 2) + normalDirection.dy * cos(radian / 2)
            )
            return endVector.scaleTo(self.radius)
        }
    }
    
    override var startPoint: CGPoint {
        get {
            return CGPoint(
                x: CGFloat(center.x) + self.scaledStartVector.dx,
                y: CGFloat(center.y) + self.scaledStartVector.dy
            )
        }
    }
    
    override var endPoint: CGPoint {
        get {
            return CGPoint(
                x: CGFloat(center.x) + self.scaledEndVector.dx,
                y: CGFloat(center.y) + self.scaledEndVector.dy
            )
        }
    }
    
    // radian will be [0, 2*Pi)
    
    var startRadian: CGFloat {
        get {
            var result = self.normalDirection.angleFromXPlus - self.radian / 2
            return result.restrictWithin2Pi
        }
    }
    
    var endRadian: CGFloat {
        get {
            var result = self.normalDirection.angleFromXPlus + self.radian / 2
            return result.restrictWithin2Pi
        }
    }
    
    
    override func getIntersectionPoint(ray: GORay) -> CGPoint? {
        let lineOfRay = ray.line
        let r1 = CGFloat(self.center.x)
        let r2 = CGFloat(self.center.y)
        let r = self.radius
        
        // handle dy=0 separatel
        // in this case, the slope is not calculatable
        if fabs(lineOfRay.direction.dx - 0) < GOConstant.overallPrecision {
            let x = ray.startPoint.x
            let squareSide = r * r - (x - r1) * (x - r1)
            if squareSide < 0 {
                return nil
            } else {
                let root = sqrt(squareSide)
                let y1 = r2 + root
                let y2 = r2 - root
                let point1 = CGPoint(x: x, y: y1)
                let point2 = CGPoint(x: x, y: y2)
                
                // check if point 1 is on ray
                if let xOnRay = ray.getX(y: y1) {
                    if let xOnRay = ray.getX(y: y2) {
                        // both point1 and point2 are on the ray
                        if GOUtilities.getDistanceBetweenPoint(ray.startPoint, andPoint: point1) >
                            GOUtilities.getDistanceBetweenPoint(ray.startPoint, andPoint: point2) {
                                // point 2 is nearer, i.e contact earlier
                                if self.containsPoint(point2) {
                                    // confirm that point 2 is on the arc
                                    if point2.isNearEnough(ray.startPoint) {
                                        // this is the case that the intersection point is exactly the contact point
                                        return nil
                                    } else {
                                        return point2
                                    }
                                }
                        }
                        
                        // point 1 is nearer
                        if self.containsPoint(point1) {
                            // point 1 is on the arc
                            if point1.isNearEnough(ray.startPoint) {
                                return nil
                            } else {
                                return point1
                            }
                        } else {
                            return nil
                        }
                    } else {
                        // point 2 is not on the ray
                        if self.containsPoint(point1) {
                            // point 1 is on the arc {
                            if point1.isNearEnough(ray.startPoint) {
                                return nil
                            } else {
                                return point1
                            }
                        } else {
                            return nil
                        }
                    }
                } else {
                    // point 1 is not on the ray
                    if let xOnRay = ray.getX(y: y2) {
                        // only point 2 is on the ray
                        if self.containsPoint(point2) {
                            // point 2 is on the arc {
                            if point2.isNearEnough(ray.startPoint) {
                                return nil
                            } else {
                                return point2
                            }
                        } else {
                            return nil
                        }
                    } else {
                        // no point is eligible to be the intersection point
                        return nil
                    }
                }
            }
        } else {
            let k = lineOfRay.slope
            let c = lineOfRay.yIntercept
            
            if c == nil {
                return nil
            }
            
            // from the equation, generate the term for the quadratic equation
            
            let termA = 1 + k * k
            let termB = 2 * ((c! - r2) * k - r1)
            let termC = r1 * r1 + (r2 - c!) * (r2 - c!) - r * r
            
            let xs = GOUtilities.solveQuadraticEquation(termA, b: termB, c: termC)
            
            if xs.0 == nil {
                // no solution
                return nil
            } else if xs.1 == nil {
                // only one intersection point, tangent
                if let y = ray.getY(x: xs.0!) {
                    // the point is on the ray
                    let point = CGPoint(x: xs.0!, y: y)
                    if self.containsPoint(point) {
                        // the point is on the arc
                        if point.isNearEnough(ray.startPoint) {
                            return nil
                        } else {
                            return point
                        }
                    } else {
                        // the point is not valid
                        return nil
                    }
                } else {
                    // the point is not on the ray
                    return nil
                }
            } else {
                // we have two solutions for the equation, validate both of the points
                if let y0 = ray.getY(x: xs.0!) {
                    if let y1 = ray.getY(x: xs.1!) {
                        if GOUtilities.getDistanceBetweenPoint(ray.startPoint, andPoint: CGPoint(x: xs.0!, y: y0)) >
                            GOUtilities.getDistanceBetweenPoint(ray.startPoint, andPoint: CGPoint(x: xs.1!, y: y1)) {
                                // the second point is nearer to the contact point
                                let point = CGPoint(x: xs.1!, y: y1)
                                if self.containsPoint(point) {
                                    if point.isNearEnough(ray.startPoint) {
                                        return nil
                                    } else {
                                        return point
                                    }
                                }
                        }
                        
                        // the first point is nearer
                        let point = CGPoint(x: xs.0!, y: y0)
                        if self.containsPoint(point) {
                            if point.isNearEnough(ray.startPoint) {
                                return nil
                            } else {
                                return point
                            }
                        } else {
                            return nil
                        }
                    } else {
                        let point = CGPoint(x: xs.0!, y: y0)
                        if self.containsPoint(point) {
                            if point.isNearEnough(ray.startPoint) {
                                return nil
                            } else {
                                return point
                            }
                        } else {
                            return nil
                        }
                    }
                } else {
                    // the first point is invalid, we just check y1
                    if let y1 = ray.getY(x: xs.1!) {
                        let point = CGPoint(x: xs.1!, y: y1)
                        if self.containsPoint(point) {
                            if point.isNearEnough(ray.startPoint) {
                                return nil
                            } else {
                                return point
                            }
                        } else {
                            return nil
                        }
                    } else {
                        return nil
                    }
                }
            }
        }
    }
    
    // the GORay is the refraction ray, the boolean value marks whether the ray is caused by total reflection
    override func getRefractionRay(#rayIn: GORay, indexIn: CGFloat, indexOut: CGFloat) -> (GORay, Bool)? {
        if let intersectionPoint = self.getIntersectionPoint(rayIn) {
            let l = rayIn.direction.normalised
            let tangentNormal = CGVector(dx: intersectionPoint.x - self.center.x,
                dy: intersectionPoint.y - self.center.y)
            let deg = M_PI / 2
            var n: CGVector
            
            if CGVector.dot(rayIn.direction, v2: tangentNormal) < 0 {
                n = tangentNormal.normalised
            } else {
                n = CGVectorMake(-tangentNormal.dx, -tangentNormal.dy).normalised
            }

            let cosTheta1 = -CGVector.dot(n, v2: l)
            let cosTheta2 = sqrt(1 - (indexIn / indexOut) * (indexIn / indexOut) * (1 - cosTheta1 * cosTheta1))
            
            // total reflection
            if 1 - (indexIn / indexOut) * (indexIn / indexOut) * (1 - cosTheta1 * cosTheta1) < 0 {
                if let reflectionRay = self.getReflectionRay(rayIn: rayIn) {
                    return (reflectionRay, true)
                } else {
                    return nil
                }
            }
            
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
            let tangentNormal = CGVector(dx: intersectionPoint.x - self.center.x,
                dy: intersectionPoint.y - self.center.y)
            let deg = M_PI / 2
            let tangent = tangentNormal.rotate(CGFloat(deg))
            
            // calculate the ray
            let tangentAngle = tangent.angleFromXPlus
            let reflectionAngle = 2 * tangentAngle + CGFloat(2 * M_PI) - rayIn.direction.angleFromXPlus
            var reflectDirection = GOUtilities.vectorFromRadius(reflectionAngle)
            
            return GORay(startPoint: intersectionPoint, direction: reflectDirection)
        } else {
            return nil
        }
    }

    
    func containsPoint(point: CGPoint) -> Bool {
        if ((point.getDistanceToPoint(self.center) - self.radius).abs <= GOConstant.overallPrecision) {
            let pointRadian = point.getRadiusFrom(self.center).restrictWithin2Pi
            let normalRadian = self.normalDirection.angleFromXPlus
            let maxRadian = max(self.startRadian, self.endRadian)
            let minRadian = min(self.startRadian, self.endRadian)
        
            if normalRadian > maxRadian || normalRadian < minRadian {
                return pointRadian > maxRadian || pointRadian < minRadian
            } else {
                return pointRadian <= maxRadian && pointRadian >= minRadian
            }
        } else {
            return false
        }
    }
    
}
