//
//  GOPath.swift
//  GridOptic
//
//  Created by NULL on 05/04/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit

class GOPath {
    var criticalPoints = [CGPoint]()
    var bezierPath: UIBezierPath
    
    init(bezierPath: UIBezierPath, criticalPoints: [CGPoint]) {
        self.bezierPath = bezierPath
        self.criticalPoints = criticalPoints
    }
}