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
    private let sectionTitleForAudio = "audio"

    private let numOfExtraSection = 2
    
    private let sectionIDForLevelDesigner = 0
    private let sectionIDForAudio = 1
    private let sectionIDForGameCenter = 2
    private let sectionIDForSupport = 3
    
    private let headerHeight:CGFloat = 50.0
    
    @IBOutlet weak var tableView: UITableView!
    class func getInstance() -> SettingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = StoryboardIndentifier.Setting
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as SettingViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.alwaysBounceVertical = false
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == sectionIDForLevelDesigner {
            let cell = tableView.dequeueReusableCellWithIdentifier(textCellId, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "Level Designer"
            return cell
        } else if indexPath.section == sectionIDForSupport {
            let cell = tableView.dequeueReusableCellWithIdentifier(textCellId, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = getStaticSupportItems()[indexPath.row]
            return cell
        } else if indexPath.section == sectionIDForGameCenter {
            let cell = tableView.dequeueReusableCellWithIdentifier(textCellId, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = getStaticGameCenterSupportItems()[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(settingCellID, forIndexPath: indexPath) as SettingViewCell
            cell.title.text = "background music"
            cell.toggle.addTarget(self, action: "toggleSetting:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.toggle.tag = indexPath.item
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sectionIDForLevelDesigner {
            return 1
        } else if section == sectionIDForSupport {
            return 3
        } else if section == sectionIDForGameCenter {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UIView(frame: CGRectMake(0, 0, 300, 50))
        let textLabel = UILabel(frame: CGRectMake(5, 5, 300, 40))
        textLabel.text = getSectionHeader(section)
        textLabel.textColor = UIColor(red: 67/255, green: 94/255, blue: 118/255, alpha: 1.0)
        textLabel.font = UIFont.systemFontOfSize(28.0)
        header.addSubview(textLabel)
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let section = indexPath.section
        if section == sectionIDForLevelDesigner {
            let viewController = LevelDesignerViewController.getInstance()
            self.presentViewController(viewController, animated: true, completion: nil)
        } else if section == sectionIDForGameCenter {
            if indexPath.item == 0 {
                // item 1 : view achievements
                dispatch_async(dispatch_get_main_queue(), {
                    GamiCent.showAchievements(completion: nil)
                })
            } else {
                // item 2 : view leaderboard
                dispatch_async(dispatch_get_main_queue(), {
                    GamiCent.showLeaderboard(leaderboardID: XGameCenter.leaderboardID, completion: nil)
                })
            }
        }
    }
    
    func toggleSetting(sender:UIButton!) {
        sender.selected = !sender.selected
    }
    
    
    private func getSectionHeader(section: Int) -> String? {
        if section == sectionIDForAudio {
            return sectionTitleForAudio
        } else if section == sectionIDForSupport {
            return sectionTitleForSupport
        } else {
            return sectionTitleForGameCenter
        }
    }
    
    private func getStaticGameCenterSupportItems() -> [String] {
        var cellItems = ["achievements", "leaderboards"]
        return cellItems
    }
    
    private func getStaticSupportItems() -> [String] {
        var cellItems = ["rate us", "credits", "feedback"]
        return cellItems
    }
}
