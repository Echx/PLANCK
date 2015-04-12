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
    private let sectionInsets = UIEdgeInsets(top: 15.0, left: 20.0, bottom: 10.0, right: 15.0)
    
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
            header.title.text = "Echx Present"
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
    
//    func collectionView(collectionView: UICollectionView!,
//        layout collectionViewLayout: UICollectionViewLayout!,
//        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//            return sectionInsets
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 15.0
//    }
    
    private func loadLevels() {
        // find out the document path
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as NSString
        let fileManager = NSFileManager.defaultManager()
        let fileArray = fileManager.contentsOfDirectoryAtPath(path,
            error: nil)! as NSArray
        
        var levelFileLoader = StorageManager.defaultManager
        
        // clear the level cache
        levelArray.removeAll(keepCapacity: true)
        // iterate each filename to add
        for filename in fileArray {
            if ((filename.pathExtension) != nil) {
                if (filename.pathExtension == StorageDefault.levelDataType) {
                    let game = levelFileLoader.loadLevel(filename as NSString)
                    levelArray.append(game)
                }
            }
        }
    }

}
