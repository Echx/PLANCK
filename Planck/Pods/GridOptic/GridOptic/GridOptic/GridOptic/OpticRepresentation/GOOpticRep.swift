//
//  GOOpticRep.swift
//  GridOptic
//
//  Created by Jiang Sheng on 1/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOOpticRep: NSObject {
    var edges = [GOSegment]()
    
    var numOfEdges : Int {
        get {
            return edges.count
        }
    }
    
    var refractionIndex : CGFloat = 1.0
    
}
