//
//  LevelSelectCollectionViewCell.swift
//  Planck
//
//  Created by Jiang Sheng on 7/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class LevelSelectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var status: UIImageView!
    
    override func prepareForReuse() {
        self.status.image = nil
    }
    
    /// set the level status based on the given infomation
    func setUpStatus(score: Int, isUnlock: Bool) {
        if !isUnlock {
            self.alpha = 0.5
        }
        
        switch score {
            case 1:
                self.status.image = UIImage(named: "onestar")
            case 2:
                self.status.image = UIImage(named: "twostar")
            case 3:
                self.status.image = UIImage(named: "clear")
            default:
                self.status.image = nil
        }
    }
}
