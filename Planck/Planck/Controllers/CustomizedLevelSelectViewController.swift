//
//  LevelSelectViewController
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class CustomizedLevelSelectViewController: ScrollPageContentViewController, UICollectionViewDataSource, UICollectionViewDelegate {
        
    @IBOutlet weak var collectionView: UICollectionView!
    var levelArray:[GameLevel] = [GameLevel]()
    
    class func getInstance() -> CustomizedLevelSelectViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = StoryboardIndentifier.CustomizedLevelSelect
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as CustomizedLevelSelectViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        reload()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseableID.CustomizedLevelSelectCell , forIndexPath: indexPath) as CustomizedLevelCollectionViewCell
        let game = levelArray[indexPath.item]
        
        cell.title.text = game.name
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
        let game = levelArray[indexPath.item]
        if game.isUnlock {
            // load game to the game view
            var gameVC = GameViewController.getInstance(game.deepCopy(), isPreview: false)
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
        return "Customized"
    }
    
    private func loadLevels() {
        self.levelArray = StorageManager.defaultManager.loadAllUserLevel()
    }
}
