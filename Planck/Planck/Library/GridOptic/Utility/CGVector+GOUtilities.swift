//
//  GOUtilities.swift
//  GridOptic
//
//  Created by Lei Mingyu on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

extension CGVector: Printable {
    
    public var description: String {
        get {
            return "(dx: \(self.dx), dy: \(self.dy))"
        }
    }
    
    var length: CGFloat {
        get {
            return sqrt(self.dx * self.dx + self.dy * self.dy)
        }
    }
    
    var normalised: CGVector {
        let length = self.length
        return CGVectorMake(self.dx / length, self.dy / length)
    }
    
    func scaleTo(length: CGFloat) -> CGVector {
        let currentLength = self.length
        let newDx = self.dx * length / self.length
        let newDy = self.dy * length / self.length
        return CGVector(dx: newDx, dy: newDy)
    }
    
    //give result in [0, 2PI)
    var angleFromXPlus: CGFloat {
        get {
            var rawAngle = CGFloat(atan(self.dy / self.dx))
            
            if self.dx > 0 && self.dy > 0 {
                return rawAngle
            } else if self.dx < 0 && self.dy > 0 {
                return CGFloat(M_PI) + rawAngle
            } else if self.dx < 0 && self.dy < 0 {
                return CGFloat(M_PI) + rawAngle
            } else if self.dx > 0 && self.dy < 0 {
                return CGFloat(2 * M_PI) + rawAngle
            } else if self.dx == 0 && self.dy < 0 {
                return CGFloat(M_PI * 3 / 2)
            } else if self.dx == 0 && self.dy > 0 {
                return CGFloat(M_PI/2)
            } else if self.dy == 0 && self.dx < 0 {
                return CGFloat(M_PI)
            } else if self.dy == 0 && self.dx > 0 {
                return CGFloat(0)
            } else {
                println(self)
                fatalError("undefined angle")
            }
        }
    }
    

    static func vectorFromXPlusRadius(radius: CGFloat) -> CGVector{
        return CGVectorMake(cos(radius), sin(radius))
    }
    
    static func dot(v1: CGVector, v2: CGVector) -> CGFloat {
        return v1.dx * v2.dx + v1.dy * v2.dy
    }
    
    func rotate(deg: CGFloat) -> CGVector {
        let newDx = self.dx * cos(deg) - self.dy * sin(deg)
        let newDy = self.dx * sin(deg) + self.dy * cos(deg)
        
        return CGVector(dx: newDx, dy: newDy)
    }
}

