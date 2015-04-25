//
//  GOPath.swift
//  GridOptic
//
//  Created by Wang Jinghan on 05/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOPath {
    var criticalPoints = [CGPoint]()
    var bezierPath: UIBezierPath
    
    var pathLength: CGFloat {
        get {
            if criticalPoints.count <= 1 {
                return 0
            } else {
                var distance: CGFloat = 0
                var prevPoint = criticalPoints[0]
                for index in 1...criticalPoints.count - 1 {
                    distance += prevPoint.getDistanceToPoint(criticalPoints[index])
                    prevPoint = criticalPoints[index]
                }
                return distance
            }
        }
    }
    init(bezierPath: UIBezierPath, criticalPoints: [CGPoint]) {
        self.bezierPath = bezierPath
        self.criticalPoints = criticalPoints
    }
}