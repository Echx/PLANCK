//
//  CGVector+XUtility.swift
//  Planck
//
//  Created by Wang Jinghan on 12/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import CoreGraphics

extension CGVector {
    var length: CGFloat {
        get {
            return sqrt(self.dx * self.dx + self.dy * self.dy)
        }
    }
    
    var angleFromNorm: CGFloat {
        get {
            return CGFloat(-atan(self.dx / self.dy))
        }
    }
    
    var angleFromXPlus: CGFloat {
        get {
            var angle = CGFloat(atan(self.dy / self.dx))
            return angle > 0 ? angle : angle + CGFloat(M_PI)
        }
    }
    
    static func vectorFromRadius(radius: CGFloat) -> CGVector{
        return CGVectorMake(cos(radius), sin(radius))
    }
    
    static func dot(v1: CGVector, v2: CGVector) -> CGFloat {
        return v1.dx * v2.dx + v1.dy * v2.dy
    }
}