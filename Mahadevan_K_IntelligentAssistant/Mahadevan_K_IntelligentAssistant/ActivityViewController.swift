//
//  ActivityViewController.swift
//  Mahadevan_K_IntelligentAssistant
//
//  Created by Krishnan Mahadevan on 5/20/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit
import CoreMotion

class ActivityViewController: UITableViewController {

    @IBOutlet weak var navigate: UINavigationItem!
    
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    var activities:[ActivityModel] = []
    var intelligentAssistant = IntelligentAssistantService()
    var runDate:Date = Date()
    var previousState: ActivityType = ActivityType.Sleep
    var currentState: ActivityType = ActivityType.Sleep
    var calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //start detecting motion
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { (data: CMMotionActivity!) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.detectMotion(motion: data)
                })
            })
        }
        
        //set date on local time zone
        calendar.timeZone = NSTimeZone.local
        runDate = calendar.startOfDay(for: Date())
        
        //populate the table
        setData()
        
        //update screen in every 30 seconds
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.clearAndSetData), userInfo: nil, repeats: true)
        
        //run clean up more than 3 weeks old data at the start of everyday
        Timer.scheduledTimer(timeInterval: 86400, target: self, selector: #selector(self.intelligentAssistant.cleanUpMotionData), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func nextDay(_ sender: UIBarButtonItem) {
        runDate = Calendar.current.date(byAdding: .day, value: 1, to: runDate)!
        clearAndSetData()
        navigate.title = getShortDate()
    }
    
    @IBAction func prevDay(_ sender: UIBarButtonItem) {
        runDate = Calendar.current.date(byAdding: .day, value: -1, to: runDate)!
        activities.removeAll()
        clearAndSetData()
        navigate.title = getShortDate()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count > 0 ? activities.count : 1
    }

    private func detectMotion(motion: CMMotionActivity!) {
        if previousState != getCurrentActivity(motion) {
            
            //update new state in coredata
            let motionData = MotionDataModel(activityId: currentState.rawValue, activityName: currentState.description, start: Date(), location: (0.0, 0.0), steps: 0)
            intelligentAssistant.saveMotionData(motion: motionData)
            
            //update previous state to current state
            previousState = currentState
        }
    }
    
    @objc private func setData() {
        //record walking steps for the day
       
        if intelligentAssistant.isEnabled(ActivityType.Walk) {
            if CMPedometer.isStepCountingAvailable() {
                self.pedoMeter.queryPedometerData(from: runDate as Date, to: self.getEndOfDay()) { (data : CMPedometerData!, error) -> Void in
                    DispatchQueue.main.async(execute: { () -> Void in
                        if(error == nil){
                            let activityModel = ActivityModel(activityName: ActivityType.Walk.description, datestart: self.runDate as Date, location: "", steps: Int(data.numberOfSteps))
                            self.activities.append(activityModel)
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }

        //get everthing else
        activities.append(contentsOf: intelligentAssistant.getActivitiesForTheDay(runDate))
        self.tableView.reloadData()
    }
    
    @objc private func clearAndSetData() {
        activities.removeAll()
        setData()
    }
    
    private func getEndOfDay() -> Date {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.current.date(byAdding: (components as DateComponents) as DateComponents, to: self.runDate as Date)!
    }
    
    private func getCurrentActivity(_ motion: CMMotionActivity!) -> ActivityType {
        if motion.stationary == true {
            currentState = ActivityType.Sleep
            
        } else if motion.walking == true {
            currentState = ActivityType.Walk
            
        } else if motion.running == true {
            currentState = ActivityType.Run
            
        } else if motion.automotive == true {
            currentState = ActivityType.Drive
        }
        return currentState
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if activities.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "activitiesToday", for: indexPath)
            cell.textLabel?.text = activities[indexPath.row].activityName
            
            if (activities[indexPath.row].activityName == ActivityType.Walk.description) {
                cell.detailTextLabel?.text = "\(activities[indexPath.row].steps) Steps"
            }
            else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                cell.detailTextLabel?.text = dateFormatter.string(from: activities[indexPath.row].datestart)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeholder", for: indexPath)
            return cell
        }
    }
   
    private func getShortDate() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: runDate)
    }
}
