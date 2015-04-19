//
//  LevelSelectViewController
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class LevelSelectViewController: ScrollPageContentViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        reload()
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
        cell.setUpStatus(game.bestScore, isUnlock: game.isUnlock)
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
        if game.isUnlock {
            // load game to the game view
            var gameVC = GameViewController.getInstance(game.deepCopy(), isPreview: false)
            // stop playing music
            NSNotificationCenter.defaultCenter().postNotificationName(HomeViewDefaults.stopPlayingKey, object: nil)
            
            self.parentScrollPageVC!.mm_drawerController()!.closeDrawerAnimated(true, completion: {
                bool in
                    self.parentScrollPageVC!.presentViewController(gameVC, animated: true, completion: {})
            })
        }
    }
    
    override func reload() {
        self.loadLevels()
        self.collectionView.reloadData()
    }
    
    private func getSectionHeaderText(section : Int) -> String {
        switch section {
        case 0:
            return "Planck 101"
        case 1:
            return "Rock Hero"
        case 2:
            return "Piano Story"
        case 3:
            return "wow, such Pop"
        default:
            return "ECHX Present"
        }
    }
    
    private func loadLevels() {
        self.levelArray = StorageManager.defaultManager.loadAllLevel()
    }
}
