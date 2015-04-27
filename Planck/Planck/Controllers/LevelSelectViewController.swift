//
//  LevelSelectViewController
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

// This controller controls the system level select view (where player can choose
// a level provided by the game when it is first install to play)
class LevelSelectViewController: ScrollPageContentViewController,
    UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let nameChar = ["I", "II", "III", "IV", "V", "VI"]
    private let headerTexts = ["Planck 101", "Rock Hero", "Piano Story",
        "wow, such Pop", "Baroque & Romantic", "The Games", "S$900!!!"]
    private let defaultHeaderText = "Echx Presents"
    var levelArray:[GameLevel] = [GameLevel]()
    
    class func getInstance() -> LevelSelectViewController {
        let storyboard = UIStoryboard(
            name: StoryboardIdentifier.StoryBoardID, bundle: nil)
        let identifier = StoryboardIdentifier.LevelSelect
        let viewController = storyboard.instantiateViewControllerWithIdentifier(
            identifier) as! LevelSelectViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        reload()
    }
    
    //reload levels
    override func reload() {
        self.loadLevels()
        self.collectionView.reloadData()
    }
    
    //get the header text for each section
    private func getSectionHeaderText(section : Int) -> String {
        if section < self.headerTexts.count {
            return self.headerTexts[section]
        } else {
            return self.defaultHeaderText
        }
    }
    
    //load levels from storage manager
    private func loadLevels() {
        self.levelArray = StorageManager.defaultManager.loadAllLevel()
    }
    
    //MARKS: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (levelArray.count + Constant.levelInSection - 1) / Constant.levelInSection
    }
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        if levelArray.count >= (section + 1) * Constant.levelInSection {
            // can afford #itemsInSection
            return Constant.levelInSection
        } else {
            return levelArray.count - section * Constant.levelInSection
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            ReuseableID.LevelSelectCell , forIndexPath: indexPath)
            as! LevelSelectCollectionViewCell
        let game = levelArray[
            indexPath.section * Constant.levelInSection + indexPath.item
        ]

        
        cell.title.text = nameChar[indexPath.item]
        cell.setUpStatus(game.bestScore, isUnlock: game.isUnlock)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: ReuseableID.LevelSelectHeader,
                forIndexPath: indexPath
            ) as! LevelSelectHeaderView
            header.title.text = getSectionHeaderText(indexPath.section)
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    
    //MARK -UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let game = levelArray[
            indexPath.section * Constant.levelInSection + indexPath.item
        ]
        if game.isUnlock {
            // load game to the game view
            var gameVC = GameViewController.getInstance(
                game.deepCopy(),
                isPreview: false
            )
            // stop playing music
            NSNotificationCenter.defaultCenter().postNotificationName(
                HomeViewDefaults.stopPlayingKey,
                object: nil
            )
            
            self.parentScrollPageVC!.getDrawerController()!.closeDrawerAnimated(
                true,
                completion: {
                    bool in
                    self.parentScrollPageVC!.presentViewController(
                        gameVC,
                        animated: true,
                        completion: nil)
            })
        }
    }
}
