//
//  GOFlatOpticRep.swift
//  GridOptic
//
//  Created by NULL on 01/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class GOFlatOpticRep: GOOpticRep {
    var type = DeviceType.Mirror
    var thickness: NSInteger
    var length: NSInteger
    var center: GOCoordinate
    var direction: CGVector = CGVectorMake(0, 1)
    var normalDirection: CGVector {
        get {
            if self.direction.dx > 0 {
                return CGVectorMake(-self.direction.dy, self.direction.dx)
            } else if self.direction.dx == 0 && self.direction.dy < 0 {
                return CGVectorMake(-self.direction.dy, 0)
            } else {
                return CGVectorMake(self.direction.dy, -self.direction.dx)
            }
        }
    }
    
    
    init(center: GOCoordinate, thickness: NSInteger, length: NSInteger, direction: CGVector) {
        self.center = center
        self.thickness = thickness
        self.length = length
        super.init()
        self.setUpEdges()
        self.setDirection(direction)
    }
    
    func setDeviceType(type: DeviceType) {
        self.type = type
        self.updateEdgesType()
    }
    
    private func setUpEdges() {
        //left edge
        let centerLeftEdge = CGPointMake(CGFloat(self.center.x) - CGFloat(self.thickness)/2, CGFloat(self.center.y))
        let leftEdge = GOLineSegment(center: centerLeftEdge, length: self.length, direction: self.direction)
        leftEdge.tag = 0
        self.edges.append(leftEdge)
        
        //right edge
        let centerRightEdge = CGPointMake(CGFloat(self.center.x) + CGFloat(self.thickness)/2, CGFloat(self.center.y))
        let rightEdge = GOLineSegment(center: centerRightEdge, length: self.length, direction: self.direction)
        leftEdge.tag = 0
        self.edges.append(rightEdge)
        
        //top edge
        let centerTopEdge = CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y) + CGFloat(self.length)/2)
        let topEdge = GOLineSegment(center: centerTopEdge, length: self.thickness, direction: self.normalDirection)
        leftEdge.tag = 1
        self.edges.append(topEdge)
        
        //bottom edge
        let centerBottomEdge = CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y) - CGFloat(self.length)/2)
        let bottomEdge = GOLineSegment(center: centerBottomEdge, length: self.thickness, direction: self.normalDirection)
        leftEdge.tag = 1
        self.edges.append(bottomEdge)
    }
    
    private func updateEdgesType() {
        for edge in self.edges {
            switch self.type {
            case DeviceType.Mirror:
                edge.willReflect = true
                edge.willRefract = false
            case DeviceType.Lens:
                edge.willReflect = false
                edge.willRefract = true
            case DeviceType.Wall:
                edge.willReflect = false
                edge.willRefract = false
            default:
                fatalError("Device Type Not Defined")
            }
        }
    }
    
    func setDirection(direction: CGVector) {
        self.direction = direction
        
        for edge in self.edges {
            if edge.tag == 0 {
                var newCenter = edge.center.getPointAfterRotation(about: self.center.point, toAngle: direction.angleFromXPlus)
                edge.direction = self.direction
            } else {
                var newCenter = edge.center.getPointAfterRotation(about: self.center.point, toAngle: direction.angleFromXPlus)
                edge.direction = self.normalDirection
            }
        }
    }
}
