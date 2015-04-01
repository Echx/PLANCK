//
//  GOGrid.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOGrid: NSObject {
    var unitLength: CGFloat
    var width: NSInteger
    var height: NSInteger
    var origin: CGPoint = CGPointZero
    var size: CGSize {
        get {
            return CGSizeMake(CGFloat(self.width) * self.unitLength, CGFloat(self.height) * self.unitLength)
        }
    }
    
    init(width: NSInteger, height: NSInteger, andUnitLength unitLength: CGFloat) {
        self.width = width
        self.height = height
        self.unitLength = unitLength
        super.init()
    }
    
    init(coordinate: GOCoordinate, andUnitLength unitLength: CGFloat) {
        self.width = coordinate.x
        self.height = coordinate.y
        self.unitLength = unitLength
        super.init()
    }
    
    func getCenterForGridCell(coordinate: GOCoordinate) -> CGPoint {
        return CGPointMake(origin.x + CGFloat(coordinate.x) * self.unitLength,
                           origin.y + CGFloat(coordinate.y) * self.unitLength)
    }
    
    func getGridCoordinateForPoint(point: CGPoint) {
        var x = round(point.x / self.unitLength - 0.5)
        var y = round(point.y / self.unitLength - 0.5)
    }

}
