//
//  GOConcaveLensRep.swift
//  GridOptic
//
//  Created by Jiang Sheng on 1/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

// GOConcaveLensRep represents the physics body of a concave lens.
// A concave lens is formed by four edges: 2 line segments and 2 arc segments, 
// and we store the shape of the concave lens by the thickess of the center and 
// edge, as well as the curvature radius of the arc
class GOConcaveLensRep: GOOpticRep {
    var thicknessCenter: CGFloat = ConcaveLensRepDefaults.defaultThicknessCenter
    var thicknessEdge: CGFloat = ConcaveLensRepDefaults.defaultThicknessEdge
    var curvatureRadius: CGFloat = ConcaveLensRepDefaults.defaultCurvatureRadius
    
    var thicknessDifference: CGFloat {
        get {
            return self.thicknessEdge - self.thicknessCenter
        }
    }
    
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
            return 2 * sqrt(self.curvatureRadius * self.curvatureRadius -
                (self.curvatureRadius - self.thicknessDifference / 2) *
                (self.curvatureRadius - self.thicknessDifference / 2))
        }
    }
    
    override var bezierPath: UIBezierPath {
        get {
            var path1 = UIBezierPath()
            path1.appendPath(self.edges[ConcaveLensRepDefaults.rightArcTag].bezierPath)
            path1.addLineToPoint(self.edges[ConcaveLensRepDefaults.topEdgeTag].center)
            path1.addLineToPoint(self.edges[ConcaveLensRepDefaults.bottomEdgeTag].center)
            path1.closePath()
            
            var path2 = UIBezierPath()
            path2.appendPath(self.edges[ConcaveLensRepDefaults.leftArcTag].bezierPath)
            path2.addLineToPoint(self.edges[ConcaveLensRepDefaults.bottomEdgeTag].center)
            path2.addLineToPoint(self.edges[ConcaveLensRepDefaults.topEdgeTag].center)
            path2.closePath()
            
            path1.appendPath(path2)

            return path1
        }
    }
    
    override var vertices: [CGPoint] {
        get {
            let angle = self.direction.angleFromXPlus
            let length = self.length
            let width = self.thicknessEdge
            let originalPoints = [
                CGPointMake(-length/2, -width/2),
                CGPointMake(length/2, -width/2),
                CGPointMake(length/2, width/2),
                CGPointMake(-length/2, width/2)
            ]
            
            var finalPoints = [CGPoint]()
            for point in originalPoints {
                finalPoints.append(CGPoint.getPointAfterRotation(angle, from: point,
                    translate: CGPointMake(CGFloat(self.center.x), CGFloat(self.center.y))))
            }
            
            return finalPoints
        }
    }
    
    init(center: GOCoordinate, direction: CGVector, thicknessCenter: CGFloat, thicknessEdge: CGFloat,
        curvatureRadius: CGFloat, id: String, refractionIndex: CGFloat) {
        self.thicknessCenter = thicknessCenter
        self.thicknessEdge = thicknessEdge
        self.curvatureRadius = curvatureRadius
        super.init(id: id, center: center)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(direction)
        self.setDeviceType(DeviceType.Lens)
        self.updateEdgesParent()
    }
    
    init(center: GOCoordinate, direction: CGVector, id: String, refractionIndex: CGFloat) {
        super.init(id: id, center: center)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(direction)
        self.updateEdgesParent()
    }
    
    init(center: GOCoordinate, id: String, refractionIndex: CGFloat) {
        super.init(id: id, center: center)
        self.refractionIndex = refractionIndex
        self.setUpEdges()
        self.setDirection(self.direction)
        self.updateEdgesParent()
    }

    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey(GOCodingKey.optic_id) as String
        let edges = aDecoder.decodeObjectForKey(GOCodingKey.optic_edges) as [GOSegment]
        let typeRaw = aDecoder.decodeObjectForKey(GOCodingKey.optic_type) as Int
        let type = DeviceType(rawValue: typeRaw)
        
        let thickCenter = aDecoder.decodeObjectForKey(GOCodingKey.optic_thickCenter) as CGFloat
        let thickEdge = aDecoder.decodeObjectForKey(GOCodingKey.optic_thickEdge) as CGFloat
        let curvatureRadius = aDecoder.decodeObjectForKey(GOCodingKey.optic_curvatureRadius) as CGFloat

        let length = aDecoder.decodeObjectForKey(GOCodingKey.optic_length) as CGFloat
        let center = aDecoder.decodeObjectForKey(GOCodingKey.optic_center) as GOCoordinate
        let direction = aDecoder.decodeCGVectorForKey(GOCodingKey.optic_direction)
        let refIndex = aDecoder.decodeObjectForKey(GOCodingKey.optic_refractionIndex) as CGFloat
        
        self.init(center: center, direction: direction, thicknessCenter: thickCenter,
                    thicknessEdge: thickEdge, curvatureRadius: curvatureRadius, id: id,
                    refractionIndex: refIndex)
        self.type = type!
        self.edges = edges
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: GOCodingKey.optic_id)
        aCoder.encodeObject(edges, forKey: GOCodingKey.optic_edges)
        aCoder.encodeObject(type.rawValue, forKey: GOCodingKey.optic_type)
        
        aCoder.encodeObject(thicknessCenter, forKey: GOCodingKey.optic_thickCenter)
        aCoder.encodeObject(thicknessEdge, forKey: GOCodingKey.optic_thickEdge)
        aCoder.encodeObject(curvatureRadius, forKey: GOCodingKey.optic_curvatureRadius)
        
        aCoder.encodeObject(length, forKey: GOCodingKey.optic_length)
        aCoder.encodeObject(center, forKey: GOCodingKey.optic_center)
        aCoder.encodeCGVector(direction, forKey: GOCodingKey.optic_direction)
        aCoder.encodeObject(refractionIndex, forKey: GOCodingKey.optic_refractionIndex)
    }
    
    override func setUpEdges() {
        self.edges = [GOSegment]()
        let radianSpan = acos((self.curvatureRadius - self.thicknessDifference / 2) / self.curvatureRadius) * 2
        
        // set up top line segment
        let centerTopEdge = CGPointMake(CGFloat(self.center.x),
            CGFloat(self.center.y) + CGFloat(self.length)/2)
        let topEdge = GOLineSegment(center: centerTopEdge,
            length: self.thicknessEdge,
            direction: self.normalDirection)
        topEdge.tag = ConcaveLensRepDefaults.topEdgeTag
        self.edges.append(topEdge)
        
        // set up right arc
        let centerRightArc = CGPointMake(CGFloat(self.center.x) +
            CGFloat(self.thicknessCenter)/2 + self.curvatureRadius, CGFloat(self.center.y))
        let rightArc = GOArcSegment(center: centerRightArc,
            radius: self.curvatureRadius,
            radian: radianSpan,
            normalDirection: self.inverseNormalDirection)
        rightArc.tag = ConcaveLensRepDefaults.rightArcTag
        self.edges.append(rightArc)
        
        // set up bottom line segment
        let centerBottomEdge = CGPointMake(CGFloat(self.center.x),
            CGFloat(self.center.y) - CGFloat(self.length)/2)
        let bottomEdge = GOLineSegment(center: centerBottomEdge,
            length: self.thicknessEdge,
            direction: self.normalDirection)
        bottomEdge.tag = ConcaveLensRepDefaults.bottomEdgeTag
        bottomEdge.revert()
        self.edges.append(bottomEdge)
        
        // set up left arc
        let centerLeftArc = CGPointMake(CGFloat(self.center.x) -
            CGFloat(self.thicknessCenter)/2 - self.curvatureRadius, CGFloat(self.center.y))
        let leftArc = GOArcSegment(center: centerLeftArc,
            radius: self.curvatureRadius,
            radian: radianSpan,
            normalDirection: self.normalDirection)
        leftArc.tag = ConcaveLensRepDefaults.leftArcTag
        self.edges.append(leftArc)
    }
    
    override func setDirection(direction: CGVector) {
        let directionDifference = direction.angleFromXPlus - self.direction.angleFromXPlus
        self.direction = direction
        
        for edge in self.edges {
            if edge.tag == ConcaveLensRepDefaults.leftArcTag {
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.normalDirection = self.normalDirection
            } else if edge.tag == ConcaveLensRepDefaults.rightArcTag {
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.normalDirection = self.inverseNormalDirection
            } else {
                edge.center = edge.center.getPointAfterRotation(about: self.center.point, byAngle: directionDifference)
                edge.direction = self.normalDirection
            }
        }
    }

}
