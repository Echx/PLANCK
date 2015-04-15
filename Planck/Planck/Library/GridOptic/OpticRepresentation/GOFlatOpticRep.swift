//
//  GOFlatOpticRep.swift
//  GridOptic
//
//  Created by Wang Jinghan on 01/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOFlatOpticRep: GOOpticRep {
    var thickness: CGFloat = 1
    var length: CGFloat = 6
    var normalDirection: CGVector {
        get {
            return CGVectorMake(self.direction.dy, -self.direction.dx)
        }
    }
    
    var inversedDirection: CGVector {
        get {
            return CGVectorMake(-self.direction.dx, -self.direction.dy)
        }
    }
    
    var inversedNormalDirection: CGVector {
        get {
            return CGVectorMake(-self.direction.dy, self.direction.dx)
        }
    }
    
    override var bezierPath: UIBezierPath {
        get {
            var path = UIBezierPath()
            
            path.moveToPoint(self.edges[1].bezierPath.currentPoint)
            path.addLineToPoint(self.edges[2].bezierPath.bezierPathByReversingPath().currentPoint)
            path.addLineToPoint(self.edges[3].bezierPath.currentPoint)
            path.addLineToPoint(self.edges[0].bezierPath.bezierPathByReversingPath().currentPoint)
            path.closePath()
            
            return path
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
    
    
    init(center: GOCoordinate, thickness: CGFloat, length: CGFloat, direction: CGVector, refractionIndex: CGFloat, id: String) {
        self.thickness = thickness
        self.length = length
        super.init(refractionIndex: refractionIndex, id: id, center: center)
        self.setUpEdges()
        self.setDirection(direction)
        self.updateEdgesParent()
    }
    
    
    init(center: GOCoordinate, thickness: CGFloat, length: CGFloat, direction: CGVector, id: String) {
        self.thickness = thickness
        self.length = length
        super.init(id: id, center: center)
        self.setUpEdges()
        self.setDirection(direction)
        self.updateEdgesParent()
    }
    
    init(center: GOCoordinate, id: String) {
        super.init(id: id, center: center)
        self.setUpEdges()
        self.setDirection(self.direction)
        self.updateEdgesParent()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey(GOCodingKey.optic_id) as String
        let edges = aDecoder.decodeObjectForKey(GOCodingKey.optic_edges) as [GOSegment]
        let typeRaw = aDecoder.decodeObjectForKey(GOCodingKey.optic_type) as Int
        let type = DeviceType(rawValue: typeRaw)
        let thick = aDecoder.decodeObjectForKey(GOCodingKey.optic_thickness) as CGFloat
        let length = aDecoder.decodeObjectForKey(GOCodingKey.optic_length) as CGFloat
        let center = aDecoder.decodeObjectForKey(GOCodingKey.optic_center) as GOCoordinate
        let direction = aDecoder.decodeCGVectorForKey(GOCodingKey.optic_direction)
        let refIndex = aDecoder.decodeObjectForKey(GOCodingKey.optic_refractionIndex) as CGFloat
        
        self.init(center: center, thickness: thick, length: length, direction: direction, id: id)
        self.type = type!
        self.edges = edges
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: GOCodingKey.optic_id)
        aCoder.encodeObject(edges, forKey: GOCodingKey.optic_edges)
        aCoder.encodeObject(type.rawValue, forKey: GOCodingKey.optic_type)
        aCoder.encodeObject(thickness, forKey: GOCodingKey.optic_thickness)
        aCoder.encodeObject(length, forKey: GOCodingKey.optic_length)
        aCoder.encodeObject(center, forKey: GOCodingKey.optic_center)
        aCoder.encodeCGVector(direction, forKey: GOCodingKey.optic_direction)
        aCoder.encodeObject(refractionIndex, forKey: GOCodingKey.optic_refractionIndex)
    }
    
//    override func containsPoint(point: CGPoint) -> Bool{
//        let areaHalfRect = self.length * self.thickness * 0.5
//        for edge in self.edges {
//            let vertexA = edge.startPoint
//            let vertexB = edge.endPoint
//            let vertexC = point
//            let areaABC = GOUtilities.areaOfTriangle(first: vertexA, second: vertexB, third: vertexC)
//            if areaABC > areaHalfRect {
//                return false
//            }
//        }
//        return true
//    }
    
    override func setUpEdges() {
        self.edges = [GOSegment]()
        //bottom edge
        let centerTopEdge = CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y) + CGFloat(self.length)/2)
        let topEdge = GOLineSegment(center: centerTopEdge, length: self.thickness, direction: self.inversedNormalDirection)
        topEdge.tag = 0
        self.edges.append(topEdge)
        
        //right edge
        let centerRightEdge = CGPointMake(CGFloat(self.center.x) + CGFloat(self.thickness)/2, CGFloat(self.center.y))
        let rightEdge = GOLineSegment(center: centerRightEdge, length: self.length, direction: self.inversedDirection)
        rightEdge.tag = 1
        self.edges.append(rightEdge)
        
        //top edge
        let centerBottomEdge = CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y) - CGFloat(self.length)/2)
        let bottomEdge = GOLineSegment(center: centerBottomEdge, length: self.thickness, direction: self.normalDirection)
        bottomEdge.tag = 2
        self.edges.append(bottomEdge)
        
        //left edge
        let centerLeftEdge = CGPointMake(CGFloat(self.center.x) - CGFloat(self.thickness)/2, CGFloat(self.center.y))
        let leftEdge = GOLineSegment(center: centerLeftEdge, length: self.length, direction: self.direction)
        leftEdge.tag = 3
        self.edges.append(leftEdge)
    }
    
    override func setDirection(direction: CGVector) {
        let directionDifference = direction.angleFromXPlus - self.direction.angleFromXPlus
        self.direction = direction
        
        for edge in self.edges {
            if edge.tag == 0 {
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.direction = self.inversedNormalDirection
            } else if edge.tag == 1{
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.direction = self.inversedDirection
            } else if edge.tag == 2{
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.direction = self.normalDirection
            } else if edge.tag == 3{
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.direction = self.direction
            }
        }
    }
}
