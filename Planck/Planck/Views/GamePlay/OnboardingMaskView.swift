//
//  OnboardingMaskView.swift
//  Planck
//
//  Created by Wang Jinghan on 19/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class OnboardingMaskView: UIView {
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func drawDashedTarget(path: UIBizierPath) {
        
    }
    
    func showTapGuidianceAtPoint(point: CGPoint) {
        
    }
    
    func showDragGuidianceAtPoint(point: CGPoint) {
        
    }
    
    func drawMask(path: UIBizierPath) {
        
    }
}
