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

//This controller controls the level select view in level designer
class DesignerLevelSelectViewController: UITableViewController {
    
    private var levelArray = [GameLevel]()
    private let numberOfSectionInTableView = 1
    
    var delegate: LevelSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFiles()
    }

    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSectionInTableView
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.levelArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseableID.DesignerLevelCell, forIndexPath: indexPath) as UITableViewCell

        let game = self.levelArray[indexPath.item]
        cell.textLabel?.text = String(game.index)
        cell.detailTextLabel?.text = game.name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let game = self.levelArray[indexPath.item]
        self.delegate!.loadSelectLevel(game)
    }

    private func loadFiles() {
        StorageManager.defaultManager.setNeedsReload()
        self.levelArray = StorageManager.defaultManager.loadAllLevel()
    }
}
