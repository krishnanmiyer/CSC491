//
//  SettingsTableViewController.swift
//  Mahadevan_K_IntelligentAssistant
//
//  Created by Krishnan Mahadevan on 6/4/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var sleepSwitch: UISwitch!
    @IBOutlet weak var walkSwitch: UISwitch!
    @IBOutlet weak var runSwitch: UISwitch!
    @IBOutlet weak var driveSwitch: UISwitch!
    
    var intelligentAssistant = IntelligentAssistantService()
    
    @IBAction func walkingSwitch(_ sender: UISwitch) {
        intelligentAssistant.saveSettings(activityId: ActivityType.Walk.rawValue, status: sender.isOn)
    }
    
    @IBAction func sleepSwitch(_ sender: UISwitch) {
        intelligentAssistant.saveSettings(activityId: ActivityType.Sleep.rawValue, status: sender.isOn)
    }
    
    @IBAction func runSwitch(_ sender: UISwitch) {
        intelligentAssistant.saveSettings(activityId: ActivityType.Run.rawValue, status: sender.isOn)
    }
    
    @IBAction func driveSwitch(_ sender: UISwitch) {
        intelligentAssistant.saveSettings(activityId: ActivityType.Drive.rawValue, status: sender.isOn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadData() {
        let settings = intelligentAssistant.getSettings()
        
        for setting in settings {
            if (setting.activityId == ActivityType.Sleep.rawValue) {
                sleepSwitch.isOn = setting.isEnabled
            }
            if (setting.activityId == ActivityType.Walk.rawValue) {
                walkSwitch.isOn = setting.isEnabled
            }
            if (setting.activityId == ActivityType.Run.rawValue) {
                runSwitch.isOn = setting.isEnabled
            }
            if (setting.activityId == ActivityType.Drive.rawValue) {
                driveSwitch.isOn = setting.isEnabled
            }
        }
    }
}
