//
//  UIBezierPath+GOUtilities.swift
//  Planck
//
//  Created by Lei Mingyu on 04/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

extension UIBezierPath {
    var criticalPointX: [CGFloat] {
        get {
            return objc_getAssociatedObject(self, "criticalPointX") as [CGFloat]
        }
        set(newValue) {
            objc_setAssociatedObject(self, "criticalPointX", newValue, UInt(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    var criticalPointY: [CGFloat] {
        get {
            return objc_getAssociatedObject(self, "criticalPointY") as [CGFloat]
        }
        set(newValue) {
            objc_setAssociatedObject(self, "criticalPointY", newValue, UInt(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    var criticalPoints: [CGPoint] {
        get {
            var points = [CGPoint]()
            for index in 0...self.criticalPointX.count - 1 {
                points.append(CGPoint(x: self.criticalPointX[index],
                    y: criticalPointY[index]))
            }
            return points
        }
    }
    
    func storeCriticalPoint(point: CGPoint) {
        self.criticalPointX.append(point.x)
        self.criticalPointY.append(point.y)
    }
}