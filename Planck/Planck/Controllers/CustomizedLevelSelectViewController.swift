//
//  LevelSelectViewController
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

// this controller is currently unsupported, we will implement customized level
// in the next iteration
class CustomizedLevelSelectViewController: ScrollPageContentViewController, UICollectionViewDataSource, UICollectionViewDelegate {
        
    @IBOutlet weak var collectionView: UICollectionView!
    var levelArray:[GameLevel] = [GameLevel]()
    private let numberOfSection = 1
    private let headerText = "Customized"
    
    class func getInstance() -> CustomizedLevelSelectViewController {
        let storyboard = UIStoryboard(
            name: StoryboardIdentifier.StoryBoardID, bundle: nil)
        let identifier = StoryboardIdentifier.CustomizedLevelSelect
        let viewController = storyboard.instantiateViewControllerWithIdentifier(
            identifier) as! CustomizedLevelSelectViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        reload()
    }
    
    override func reload() {
        self.loadLevels()
        self.collectionView.reloadData()
    }
    
    //retrieve the header text for different sections
    private func getSectionHeaderText(section : Int) -> String {
        return self.headerText
    }
    
    //load all user defined levels
    private func loadLevels() {
        self.levelArray = StorageManager.defaultManager.loadAllUserLevel()
    }
    
    //MARK -UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.numberOfSection
    }
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return levelArray.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            ReuseableID.CustomizedLevelSelectCell , forIndexPath: indexPath)
            as! CustomizedLevelCollectionViewCell
        let game = levelArray[indexPath.item]
        
        cell.title.text = game.name
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind, withReuseIdentifier: ReuseableID.UserLevelSelectHeader,
                forIndexPath: indexPath) as! LevelSelectHeaderView
            header.title.text = getSectionHeaderText(indexPath.section)
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    //MARK -UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let game = levelArray[indexPath.item]
        if game.isUnlock {
            // load game to the game view
            var gameVC = GameViewController.getInstance(
                game.deepCopy(), isPreview: false)
            self.parentScrollPageVC!.getDrawerController()!.closeDrawerAnimated(
                true, completion: {
                bool in
                    self.parentScrollPageVC!.presentViewController(
                        gameVC, animated: true, completion: nil)
            })
        }
    }
}
