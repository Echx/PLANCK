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
    var center: GOCoordinate
    var direction: CGVector = CGVectorMake(0, 1)
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
    
    
    init(center: GOCoordinate, thickness: CGFloat, length: CGFloat, direction: CGVector, refractionIndex: CGFloat, id: String) {
        self.center = center
        self.thickness = thickness
        self.length = length
        super.init(refractionIndex: refractionIndex, id: id)
        self.setUpEdges()
        self.setDirection(direction)
        self.updateEdgesParent()
    }
    
    
    init(center: GOCoordinate, thickness: CGFloat, length: CGFloat, direction: CGVector, id: String) {
        self.center = center
        self.thickness = thickness
        self.length = length
        super.init(id: id)
        self.setUpEdges()
        self.setDirection(direction)
        self.updateEdgesParent()
    }
    
    init(center: GOCoordinate, id: String) {
        self.center = center
        super.init(id: id)
        self.setUpEdges()
        self.setDirection(self.direction)
        self.updateEdgesParent()
    }
    
    override func containsPoint(point: CGPoint) -> Bool{
        let areaHalfRect = self.length * self.thickness * 0.5
        for edge in self.edges {
            let vertexA = edge.startPoint
            let vertexB = edge.endPoint
            let vertexC = point
            let areaABC = GOUtilities.areaOfTriangle(first: vertexA, second: vertexB, third: vertexC)
            if areaABC > areaHalfRect {
                println("edge")
                return false
            }
        }
        return true
    }
    
    private func setUpEdges() {
        //top edge
        let centerTopEdge = CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y) + CGFloat(self.length)/2)
        let topEdge = GOLineSegment(center: centerTopEdge, length: self.thickness, direction: self.inversedNormalDirection)
        topEdge.tag = 0
        self.edges.append(topEdge)
        
        //right edge
        let centerRightEdge = CGPointMake(CGFloat(self.center.x) + CGFloat(self.thickness)/2, CGFloat(self.center.y))
        let rightEdge = GOLineSegment(center: centerRightEdge, length: self.length, direction: self.inversedDirection)
        rightEdge.tag = 1
        self.edges.append(rightEdge)
        
        //bottom edge
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
