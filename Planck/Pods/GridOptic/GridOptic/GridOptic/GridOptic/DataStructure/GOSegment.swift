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
    var willReflect: Bool = true
    var center: CGPoint = CGPointZero
    var tag: NSInteger = 0
    
    //angle should be within [0, PI) from
    var direction: CGVector = CGVector.zeroVector
    var normalDirection: CGVector {
        set {
            if self.direction.dx > 0 {
                self.normalDirection = CGVectorMake(-self.normalDirection.dy, self.direction.dx)
            } else if self.direction.dx == 0 && self.direction.dy < 0 {
                self.normalDirection = CGVectorMake(-self.direction.dy, 0)
            } else {
                self.normalDirection = CGVectorMake(self.direction.dy, -self.direction.dx)
            }
        }
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
    
    func getIntersectionPoint(ray: GORay) -> CGPoint? {
        return nil;
    }
    
    func isIntersectedWithRay(ray: GORay) -> Bool {
        return self.getIntersectionPoint(ray) != nil
    }
    
    func getOutputRay(#rayIn: GORay, indexIn: CGFloat, indexOut: CGFloat) -> GORay? {
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
