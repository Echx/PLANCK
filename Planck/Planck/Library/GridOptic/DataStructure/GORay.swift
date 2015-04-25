//
//  GORay.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

// GORay is the representation of ray in GO library
// i.e. a line with one end
class GORay: NSObject, Printable {
    var startPoint: CGPoint
    var direction: CGVector
    
    // return the embeded GOLine
    var line: GOLine {
        get {
            return GOLine(anyPoint: self.startPoint, direction: self.direction)
        }
    }
    
    init(startPoint: CGPoint, direction: CGVector) {
        self.startPoint = startPoint
        self.direction = direction
    }
    
    override var description: String {
        return "(\(self.startPoint.x), \(self.startPoint.y)) --> direction: (\(self.direction.dx), \(self.direction.dy))"
    }
    
    //give the corresponding y of a given x, nil if not defined
    func getY(#x: CGFloat) -> CGFloat? {
        if self.direction.dx > 0 && x < self.startPoint.x {
            return nil
        }
        
        if self.direction.dx < 0 && x > self.startPoint.x {
            return nil
        }
        
        return self.line.getY(x: x)
    }

    //give the corresponding x of a given y, nil if not defined
    func getX(#y: CGFloat) -> CGFloat? {
        if self.direction.dy > 0 && y < self.startPoint.y {
            return nil
        }
        
        if self.direction.dy < 0 && y > self.startPoint.y {
            return nil
        }
        
        return self.line.getX(y: y)
    }
}
