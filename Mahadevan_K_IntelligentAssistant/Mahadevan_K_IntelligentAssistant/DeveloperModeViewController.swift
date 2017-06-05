//
//  DeveloperModeViewController.swift
//  Mahadevan_K_IntelligentAssistant
//
//  Created by Krishnan Mahadevan on 6/1/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit

class DeveloperModeViewController: UITableViewController {
   
    var intelligentAssistant = IntelligentAssistantService()
    var data:[MotionDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Developer Mode"
        loadData()
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.loadData), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count > 0 ? data.count : 10
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if data.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "motionData", for: indexPath)
            cell.textLabel?.text = data[indexPath.row].activityName
            cell.detailTextLabel?.text = data[indexPath.row].start.description
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeholder", for: indexPath)
            return cell
        }
    }

    func loadData() {
        data = intelligentAssistant.getMotionDataAll()
        self.tableView.reloadData()
    }
}
