//
//  GOCoordinate.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOCoordinate: NSObject, NSCoding {
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
    
    required convenience init(coder aDecoder: NSCoder) {
        let x = aDecoder.decodeObjectForKey(GOCodingKey.coord_x) as NSInteger
        let y = aDecoder.decodeObjectForKey(GOCodingKey.coord_y) as NSInteger
        self.init(x: x, y: y)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(x, forKey: GOCodingKey.coord_x)
        aCoder.encodeObject(y, forKey: GOCodingKey.coord_y)
    }
    
    class func GOCoordinateMake(x: NSInteger, y: NSInteger) -> GOCoordinate {
        return GOCoordinate(x: x, y: y)
    }
}
