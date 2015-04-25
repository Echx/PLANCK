//
//  LevelSelectCollectionViewCell.swift
//  Planck
//
//  Created by Jiang Sheng on 7/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

/// This is the collection cell shows the pre-defined level
class LevelSelectCollectionViewCell: UICollectionViewCell {
    // the title label of the cell
    @IBOutlet weak var title: UILabel!
    
    // a UI view indicating if the result of status
    @IBOutlet weak var status: UIImageView!
    
    // This method clears the UIImage content and prepare the 
    // cell for reuse
    override func prepareForReuse() {
        self.status.image = nil
    }
    
    /// set the level status image based on the given infomation
    func setUpStatus(score: Int, isUnlock: Bool) {
        if !isUnlock {
            self.alpha = 0.5
        }
        
        switch score {
            case 1:
                self.status.image = UIImage(named: XImageName.statusRed)
            case 2:
                self.status.image = UIImage(named: XImageName.statusOrange)
            case 3:
                self.status.image = UIImage(named: XImageName.statusGreen)
            default:
                self.status.image = nil
        }
    }
}
