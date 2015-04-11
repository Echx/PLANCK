//
//  DesignerLevelSelectViewController.swift
//  Planck
//
//  Created by Jiang Sheng on 6/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

protocol LevelSelectDelegate {
    func loadSelectLevel(level:GameLevel)
}

class DesignerLevelSelectViewController: UITableViewController {
    
    private let levelDataFileType = "dat"
    private let cellID = "LevelCell"
    private let storyBoardID = "Main"
    private let gameViewID = "GameView"
    
    // holding level names
    private var levelArray = NSMutableArray()
    
    var delegate: LevelSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadFiles()

        // Display an Edit button        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.levelArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as UITableViewCell

        let game = self.levelArray.objectAtIndex(indexPath.item) as GameLevel
        cell.textLabel?.text = game.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let game = self.levelArray.objectAtIndex(indexPath.item) as GameLevel
        self.delegate!.loadSelectLevel(game)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    private func loadFiles() {
        // find out the document path
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as NSString
        let fileManager = NSFileManager.defaultManager()
        let fileArray = fileManager.contentsOfDirectoryAtPath(path,
            error: nil)! as NSArray
        
        var levelFileLoader = StorageManager.defaultManager
        // iterate each filename to add
        for filename in fileArray {
            if ((filename.pathExtension) != nil) {
                if (filename.pathExtension == levelDataFileType) {
                    let game = levelFileLoader.loadLevel(filename as NSString)
                    levelArray.addObject(game)
                }
            }
        }
    }
}
