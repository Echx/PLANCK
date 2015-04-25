//
//  CoinView.swift
//  Planck
//
//  Created by Wang Jinghan on 12/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

/// This is the view component to display the badge that user has achieved
class BadgeView: UIView {
    
    private struct CoinImage {
        static let normal = UIImage(named: XImageName.normal)
        static let empty = UIImage(named: XImageName.empty)
    }
    
    let defaultWidth: CGFloat = 150
    var imageView: UIImageView
    
    init(isOn: Bool, width: CGFloat = 150) {
        let rect = CGRectMake(0, 0, width, width)
        self.imageView = UIImageView(frame: rect)
        super.init(frame: rect)
        if isOn {
            self.imageView.image = CoinImage.normal
        } else {
            self.imageView.image = CoinImage.empty
        }
        self.addSubview(self.imageView)
    }

    required init(coder aDecoder: NSCoder) {
        let rect = CGRectMake(0, 0, self.defaultWidth, self.defaultWidth)
        self.imageView = UIImageView(frame: rect)
        super.init(coder: aDecoder)
        self.imageView.image = CoinImage.normal
        self.addSubview(self.imageView)
    }
    
    /// Toggle the badge image based on the given boolean value
    /// :params: booleanValue a boolean indicating whether to show the bade
    func setEmpty(booleanValue: Bool) {
        if booleanValue {
            self.imageView.image = CoinImage.empty
        } else {
            self.imageView.image = CoinImage.normal
        }
    }
}
