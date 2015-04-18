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
    
    private let cellID = "LevelCell"
    private let storyBoardID = "Main"
    private let gameViewID = "GameView"
    
    // holding level names
    private var levelArray = [GameLevel]()
    
    var delegate: LevelSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadFiles()

        // Display an Edit button        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.levelArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as UITableViewCell

        let game = self.levelArray[indexPath.item]
        cell.textLabel?.text = String(game.index)
        cell.detailTextLabel?.text = game.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let game = self.levelArray[indexPath.item]
        self.delegate!.loadSelectLevel(game)
    }

    private func loadFiles() {
        // make sure read the original level
        StorageManager.defaultManager.setNeedsReload()
        self.levelArray = StorageManager.defaultManager.loadAllLevel()
    }
}
