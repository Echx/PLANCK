//
//  GOCoordinate.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOCoordinate: NSObject {
    let x: NSInteger
    let y: NSInteger
    var point: CGPoint {
        get {
            return CGPointMake(CGFloat(self.x), CGFloat(self.y))
        }
    }
    
    init(x: NSInteger, y: NSInteger) {
        self.x = x
        self.y = y
    }
    
    class func GOCoordinateMake(x: NSInteger, y: NSInteger) -> GOCoordinate {
        return GOCoordinate(x: x, y: y)
    }
}

extension GOCoordinate: Printable {
    override var description: String {
        get {
            return "Coordinate: (\(self.x), \(self.y))"
        }
    }
}