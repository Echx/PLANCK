//
//  CGVector+XUtility.swift
//  Planck
//
//  Created by Wang Jinghan on 12/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import CoreGraphics

extension CGVector {
    
    // :param: two CGVectors v1 and v2
    // returns: a CGFloat representing the angle the angle from v1 to v2 in anti-clockwise
    static func angleFrom(v1: CGVector, to v2: CGVector) -> CGFloat {
        var angle = v2.angleFromXPlus - v1.angleFromXPlus
        return angle >= 0 ? angle : angle + CGFloat(M_PI * 2)
    }
}