//
//  GOConvexLensRep.swift
//  GridOptic
//
//  Created by Jiang Sheng on 1/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOConvexLensRep: GOOpticRep {
    var thickness: CGFloat = 1
    var curvatureRadius: CGFloat = 5
    var normalDirection: CGVector {
        get {
            return CGVectorMake(self.direction.dy, -self.direction.dx)
        }
    }
    var inverseNormalDirection: CGVector {
        get {
            return CGVectorMake(-self.normalDirection.dx, -self.normalDirection.dy)
        }
    }
    
    var length: CGFloat {
        get {
            return 2 * sqrt(self.curvatureRadius * self.curvatureRadius - (self.curvatureRadius - self.thickness/2) * (self.curvatureRadius - self.thickness/2))
        }
    }
    
    override var vertices: [CGPoint] {
        get {
            let angle = self.direction.angleFromXPlus
            let length = self.length
            let width = self.thickness
            let originalPoints = [
                CGPointMake(-length/2, -width/2),
                CGPointMake(length/2, -width/2),
                CGPointMake(length/2, width/2),
                CGPointMake(-length/2, width/2)
            ]
            
            var finalPoints = [CGPoint]()
            for point in originalPoints {
                finalPoints.append(CGPoint.getPointAfterRotation(angle, from: point, translate: CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y))))
            }
            
            return finalPoints
        }
    }
    

    
    init(center: GOCoordinate, direction: CGVector, thickness: CGFloat, curvatureRadius: CGFloat, id: String, refractionIndex: CGFloat) {
        self.thickness = thickness
        self.curvatureRadius = curvatureRadius
        super.init(id: id, center: center)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(direction)
        self.updateEdgesParent()
        self.setDeviceType(DeviceType.Lens)
    }
    
    init(center: GOCoordinate, direction: CGVector, id: String, refractionIndex: CGFloat) {
        super.init(id: id, center: center)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(direction)
        self.setDeviceType(DeviceType.Lens)
        self.updateEdgesParent()
    }
    
    init(center: GOCoordinate, id: String, refractionIndex: CGFloat) {
        super.init(id: id, center: center)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(self.direction)
        self.setDeviceType(DeviceType.Lens)
        self.updateEdgesParent()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey(GOCodingKey.optic_id) as String
        let edges = aDecoder.decodeObjectForKey(GOCodingKey.optic_edges) as [GOSegment]
        let typeRaw = aDecoder.decodeObjectForKey(GOCodingKey.optic_type) as Int
        let type = DeviceType(rawValue: typeRaw)
        
        let thickness = aDecoder.decodeObjectForKey(GOCodingKey.optic_thickness) as CGFloat
        let curvatureRadius = aDecoder.decodeObjectForKey(GOCodingKey.optic_curvatureRadius) as CGFloat
        
        let length = aDecoder.decodeObjectForKey(GOCodingKey.optic_length) as CGFloat
        let center = aDecoder.decodeObjectForKey(GOCodingKey.optic_center) as GOCoordinate
        let direction = aDecoder.decodeCGVectorForKey(GOCodingKey.optic_direction)
        let refIndex = aDecoder.decodeObjectForKey(GOCodingKey.optic_refractionIndex) as CGFloat
        
        self.init(center: center, direction: direction, thickness: thickness,
                    curvatureRadius: curvatureRadius, id: id, refractionIndex: refIndex)
        self.type = type!
        self.edges = edges
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: GOCodingKey.optic_id)
        aCoder.encodeObject(edges, forKey: GOCodingKey.optic_edges)
        aCoder.encodeObject(type.rawValue, forKey: GOCodingKey.optic_type)
        
        aCoder.encodeObject(thickness, forKey: GOCodingKey.optic_thickness)
        aCoder.encodeObject(curvatureRadius, forKey: GOCodingKey.optic_curvatureRadius)
        
        aCoder.encodeObject(length, forKey: GOCodingKey.optic_length)
        aCoder.encodeObject(center, forKey: GOCodingKey.optic_center)
        aCoder.encodeCGVector(direction, forKey: GOCodingKey.optic_direction)
        aCoder.encodeObject(refractionIndex, forKey: GOCodingKey.optic_refractionIndex)
    }
    
    
    override func setUpEdges() {
        self.edges = [GOSegment]()
        let radianSpan = acos((self.curvatureRadius - self.thickness/2) / self.curvatureRadius) * 2
        
        //left arc
        let centerLeftArc = CGPointMake(CGFloat(self.center.x) + CGFloat(self.thickness)/2 - self.curvatureRadius, CGFloat(self.center.y))
        let leftArc = GOArcSegment(center: centerLeftArc, radius: self.curvatureRadius, radian: radianSpan, normalDirection: self.normalDirection)
        leftArc.tag = 0
        self.edges.append(leftArc)
        
        //right arc
        let centerRightArc = CGPointMake(CGFloat(self.center.x) - CGFloat(self.thickness)/2 + self.curvatureRadius, CGFloat(self.center.y))
        let rightArc = GOArcSegment(center: centerRightArc, radius: self.curvatureRadius, radian: radianSpan, normalDirection: self.inverseNormalDirection)
        rightArc.tag = 1
        self.edges.append(rightArc)
    }
    
    override func containsPoint(point: CGPoint) -> Bool {
        for edge in self.edges {
            if let arcEdge = edge as? GOArcSegment {
                if edge.center.getDistanceToPoint(point) > arcEdge.radius {
                    return false
                }
            }
        }
        
        return true
    }
    
    override func setDirection(direction: CGVector) {
        let directionDifference = direction.angleFromXPlus - self.direction.angleFromXPlus
        self.direction = direction
        
        for edge in self.edges {
            if edge.tag == 0 {
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.normalDirection = self.normalDirection
            } else {
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.normalDirection = self.inverseNormalDirection
            }
        }
    }
}
