//
//  NotificationsTableViewCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 21/02/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var generalNewsSwitch: UISwitch!
    @IBOutlet weak var projectInvitesSwitch: UISwitch!
    @IBOutlet weak var projectNewsSwitch: UISwitch!
    @IBOutlet weak var newCommentsSwitch: UISwitch!
    @IBOutlet weak var updateButton: RNLoadingButton!
    @IBOutlet weak var notificationIntervalButton: UIButton!
    
    var notificationInterval: String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // set button with indicator
        self.updateButton.hideTextWhenLoading = true
        self.updateButton.setActivityIndicatorAlignment(RNLoadingButtonAlignmentCenter)
        self.updateButton.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.Gray, forState: UIControlState.Disabled)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpCell(config: Dictionary<String, AnyObject>) {

        if let newComments = config["commentNotification"]?.objectForKey("value") as? Int {
            self.newCommentsSwitch.setOn((newComments == 1), animated: false)
        }
        
        if let generalNews = config["subscription"]?.objectForKey("value") as? Int {
            self.generalNewsSwitch.setOn((generalNews == 1), animated: false)
        }
        
        if let projectInvitation = config["projectInvitation"]?.objectForKey("value") as? Int {
            self.projectInvitesSwitch.setOn((projectInvitation == 1), animated: false)
        }
        
        if let projectNews = config["projectInformation"]?.objectForKey("value") as? Int {
            self.projectNewsSwitch.setOn((projectNews == 1), animated: false)
        }
        
        if let interval = config["notificationInterval"]?.objectForKey("value") as? String {
            self.setInterval(interval)
        }
    }
    
    // set interval
    func setInterval(interval: String) -> Void {
        self.notificationInterval = interval
        self.notificationIntervalButton.setTitle(interval, forState: UIControlState.Normal)
    }
}
