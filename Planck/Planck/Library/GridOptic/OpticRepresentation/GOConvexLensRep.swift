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
    var center: GOCoordinate
    var direction: CGVector = CGVectorMake(0, 1)
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
    
    init(center: GOCoordinate, direction: CGVector, thickness: CGFloat, curvatureRadius: CGFloat, id: String, refractionIndex: CGFloat) {
        self.thickness = thickness
        self.curvatureRadius = curvatureRadius
        self.center = center
        super.init(id: id)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(direction)
        self.updateEdgesParent()
        self.setDeviceType(DeviceType.Lens)
    }
    
    init(center: GOCoordinate, direction: CGVector, id: String, refractionIndex: CGFloat) {
        self.center = center
        super.init(id: id)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(direction)
        self.setDeviceType(DeviceType.Lens)
        self.updateEdgesParent()
    }
    
    init(center: GOCoordinate, id: String, refractionIndex: CGFloat) {
        self.center = center
        super.init(id: id)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(self.direction)
        self.setDeviceType(DeviceType.Lens)
        self.updateEdgesParent()
    }
    
    private func setUpEdges() {
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
