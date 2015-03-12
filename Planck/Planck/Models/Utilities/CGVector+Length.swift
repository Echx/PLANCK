//
//  CGVector+length.swift
//  Planck
//
//  Created by Wang Jinghan on 12/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import CoreGraphics

extension CGVector {
    var length: CGFloat {
        get {
            return sqrt(self.dx * self.dx + self.dy * self.dy)
        }
    }
}