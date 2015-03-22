//
//  XContactableNode.swift
//  Planck
//
//  Created by Lei Mingyu on 13/03/15.
//  Copyright (c) 2015年 Echx. All rights reserved.
//

import UIKit
import SpriteKit

protocol XContactable {
    func contactWithPhoton(photon: XPhoton)
}

protocol XContactableLens {
    func contactWithPhoton(photon: XPhoton, lensCenter:CGPoint)
}

class XContactableNode: XNode {
    
}