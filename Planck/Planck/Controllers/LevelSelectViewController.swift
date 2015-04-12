//
//  LevelSelectViewController
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class LevelSelectViewController: XViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let itemsInSection = 6
    
    @IBOutlet weak var collectionView: UICollectionView!
    var levelArray:[GameLevel] = [GameLevel]()
    
    class func getInstance() -> LevelSelectViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = StoryboardIndentifier.LevelSelect
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as LevelSelectViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadLevels()
        self.collectionView.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (levelArray.count + itemsInSection - 1) / itemsInSection
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if levelArray.count >= (section + 1) * itemsInSection {
            // can afford #itemsInSection
            return itemsInSection
        } else {
            return levelArray.count - section * itemsInSection
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseableID.LevelSelectCell , forIndexPath: indexPath) as LevelSelectCollectionViewCell
        let game = levelArray[indexPath.section * itemsInSection + indexPath.item]
        let nameChar = ["I", "II", "III", "IV", "V", "VI"]
        
        cell.title.text = nameChar[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ReuseableID.LevelSelectHeader, forIndexPath: indexPath) as LevelSelectHeaderView
            header.title.text = getSectionHeaderText(indexPath.section)
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let game = levelArray[indexPath.section * itemsInSection + indexPath.item]
        
        // load game to the game view 
        var gameVC = GameViewController.getInstance(game)
        self.presentViewController(gameVC, animated: true, completion: {})
    }
    
    private func getSectionHeaderText(section : Int) -> String {
        return "Echx Present"
    }
    
    private func loadLevels() {
        self.levelArray = StorageManager.defaultManager.loadAllLevels()
    }

}
