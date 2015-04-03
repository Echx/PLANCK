//
//  GO2DRepresentation.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOSegment {
    
    //if both are true, only take refract (ignore the reflect ray)
    var willRefract: Bool = false
    var willReflect: Bool = false
    var center: CGPoint = CGPointZero
    var tag: NSInteger = 0
    var bezierPath: UIBezierPath {
        get {
            fatalError("Property bezierPath need to be overriden by child classes")
        }
    }
    var parent: String = ""
    
    //angle should be within [0, 2PI) from
    var direction: CGVector = CGVector(dx: 0, dy: 1)
    var normalDirection: CGVector {
        set {
            self.direction = CGVectorMake(-newValue.dy, newValue.dx)
        }
        get {
            return CGVectorMake(self.direction.dy, -self.direction.dx)
        }
    }
    
    func getIntersectionPoint(ray: GORay) -> CGPoint? {
        fatalError("getIntersectionPoint must by overriden")
    }
    
    func isIntersectedWithRay(ray: GORay) -> Bool {
        return self.getIntersectionPoint(ray) != nil
    }
    
    func getOutcomeRay(#rayIn: GORay, indexIn: CGFloat, indexOut: CGFloat) -> GORay? {
        if self.willRefract {
            return self.getRefractionRay(rayIn: rayIn, indexIn: indexIn, indexOut: indexOut)
        } else if self.willReflect {
            return self.getReflectionRay(rayIn: rayIn)
        } else {
            return nil
        }
    }
    
    func getRefractionRay(#rayIn: GORay, indexIn: CGFloat, indexOut: CGFloat) -> GORay? {
        return nil
    }
    
    func getReflectionRay(#rayIn: GORay) -> GORay? {
        return nil
    }
}
