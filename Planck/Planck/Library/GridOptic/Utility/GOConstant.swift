//
//  GOConstant.swift
//  GridOptic
//
//  Created by Wang Jinghan on 01/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

struct GOConstant {
    static let angleCalculationPrecision:CGFloat = 1000
    static let overallPrecision: CGFloat = 0.00001
    static let boundaryOffset : CGFloat = 1
    static let vacuumRefractionIndex: CGFloat = 1
}

enum DeviceType: Int {
    case Lens = 0
    case Mirror, Wall, Emitter
}

struct GOCodingKey {
    static let grid_unitLength = "GRID_UNIT_LENGTH"
    static let grid_width = "GRID_WIDTH"
    static let grid_height = "GRID_HEIGHT"
    static let grid_origin = "GRID_ORIGIN"
    static let grid_bgIndex = "GRID_BG_INDEX"
    static let grid_instruments = "GRID_INSTRUMENTS"
    
    static let coord_x = "COORD_X"
    static let coord_y = "COORD_Y"
    
    static let optic_id = "OPTIC_ID"
    static let optic_edges = "OPTIC_EDGES"
    static let optic_type = "OPTIC_TYPE"
    static let optic_thickness = "OPTIC_THICK"
    static let optic_length = "OPTIC_LENGTH"
    static let optic_center = "OPTIC_CENTER"
    static let optic_direction = "OPTIC_DIRECTION"
    static let optic_refractionIndex = "OPTIC_REF_INDEX"
    static let optic_thickCenter = "OPTIC_THICK_CENTER"
    static let optic_thickEdge = "OPTIC_THICK_EDGE"
    static let optic_curvatureRadius = "OPTIC_CUR_RADIUS"

}