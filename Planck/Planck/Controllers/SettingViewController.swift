//
//  SettingViewController.swift
//  Planck
//
//  Created by Wang Jinghan on 07/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class SettingViewController: XViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let settingCellID = "SettingViewCell"
    private let textCellId = "SettingViewTextCell"
    private let sectionTitleForSupport = "support"
    private let sectionTitleForGameCenter = "game center"
    private let sectionTitleForControls = "controls"
    private let sectionTitleForAudio = "audio"
    private let sectionTitleForVideo = "video"

    private let numOfExtraSection = 2
    
    private let sectionIDForControl = 0
    private let sectionIDForAudio = 1
    private let sectionIDForVideo = 2
    private let sectionIDForSupport = 3
    private let sectionIDForGameCenter = 4
    
    class func getInstance() -> SettingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = StoryboardIndentifier.Setting
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as SettingViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return getStaticTogglableItems().count + numOfExtraSection // setting items + support + game center
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == sectionIDForSupport {
            let cell = tableView.dequeueReusableCellWithIdentifier(textCellId, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = getStaticSupportItems()[indexPath.item]
            return cell
        } else if indexPath.section == sectionIDForGameCenter {
            let cell = tableView.dequeueReusableCellWithIdentifier(textCellId, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = getStaticGameCenterSupportItems()[indexPath.item]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(settingCellID, forIndexPath: indexPath) as SettingViewCell
            cell.title.text = getStaticTogglableItems()[indexPath.section][indexPath.item]
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sectionIDForSupport {
            return getStaticSupportItems().count
        } else if section == sectionIDForGameCenter {
            return getStaticGameCenterSupportItems().count
        } else {
            return getStaticTogglableItems()[section].count
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UIView(frame: CGRectMake(0, 0, 300, 40))
//        header.backgroundColor = UIColor(red: 67, green: 94, blue: 118, alpha: 1)
        let textLabel = UILabel(frame: CGRectMake(5, 5, 300, 30))
        textLabel.text = getSectionHeader(section)
        textLabel.textColor = UIColor.whiteColor()
        header.addSubview(textLabel)
        return header
    }
    
    private func getSectionHeader(section: Int) -> String? {
        if section == sectionIDForControl {
            return sectionTitleForControls
        } else if section == sectionIDForAudio {
            return sectionTitleForAudio
        } else if section == sectionIDForVideo {
            return sectionTitleForVideo
        } else if section == sectionIDForSupport {
            return sectionTitleForSupport
        } else {
            return sectionTitleForGameCenter
        }
    }

    
    private func getStaticTogglableItems() -> [[String]] {
        var cellItems = [
            ["free rotate"], // audio setting
            ["background music"],      // control setting
            ["visual effects"]    // video setting
        ]
        return cellItems
    }
    
    private func getStaticGameCenterSupportItems() -> [String] {
        var cellItems = ["achievements", "leaderboards"]
        return cellItems
    }
    
    private func getStaticSupportItems() -> [String] {
        var cellItems = ["rate us", "credits", "feedbacl"]
        return cellItems
    }
}
