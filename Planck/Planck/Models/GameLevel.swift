//
//  GameLevel.swift
//  Planck
//
//  Created by Jiang Sheng on 5/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GameLevel: NSObject {
    
    var grid:GOGrid
    
    var name:String
    
    init(levelName:String, grid:GOGrid) {
        self.name = levelName
        self.grid = grid
    }
}
