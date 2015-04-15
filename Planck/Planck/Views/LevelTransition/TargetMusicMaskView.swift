//
//  TargetMusicMaskView.swift
//  Planck
//
//  Created by Lei Mingyu on 16/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

protocol TargetMusicMaskViewDelegate {
    func didFinishPlaying()
}

class TargetMusicMaskView: UIView {
    private let headphoneImage = UIImage(named: "headphone")
    var delegate: TargetMusicMaskViewDelegate?
    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = self.bounds
        self.addSubview(blurView)
        
        let headphoneView = UIImageView(image: self.headphoneImage)
        self.addSubview(headphoneView)
    }
    
    
    func show(targetMusic: XMusic) {
        
    }
    
    func hide() {
        self.removeFromSuperview()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

