//
//  IntelligentAssistantService.swift
//  Mahadevan_K_IntelligentAssistant
//
//  Created by Krishnan Mahadevan on 5/20/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import CoreMotion

class IntelligentAssistantService {

    func getSettings() -> [SettingsModel] {
        
        let userSettings = DataService.getSettings()
        
        var settings:[SettingsModel] = []
        
        for userSetting in userSettings {
            if let activity = ActivityType(rawValue: userSetting.activityId)?.description {
                let setting = SettingsModel(activityName: activity,
                                            isEnabled: userSetting.enabled,
                                            activityId: userSetting.activityId)
                settings.append(setting)
            }
        }
        return settings
    }
    
    func saveSettings(activityId: Int16, status: Bool) -> Void {
        DataService.saveSetting(activityId: activityId, enabled: status)
    }
    
    func getMotionDataAll() -> [MotionDataModel] {
        
        let data = DataService.getMotionData().sorted(by: { $0.start?.compare($1.start! as Date) ==  .orderedDescending})
        
        var motions:[MotionDataModel] = []
        
        for rec in data {
            if let activity = ActivityType(rawValue: rec.activityId)?.description {
                let motion = MotionDataModel(activityId: rec.activityId
                    , activityName: activity
                    , start: rec.start! as Date
                    , location: (rec.latitude, rec.longitude)
                    , steps: rec.steps)
                
                motions.append(motion)
            }
        }
        return motions
    }
    
    func saveMotionData(motion: MotionDataModel) {
        DataService.saveMotionData(activityId: motion.activityId, start: motion.start, latitude: motion.location.0, longitude: motion.location.1, steps: motion.steps)
    }
    
    @objc func cleanUpMotionData() {
        DataService.deleteArchives()
    }
    
    func getActivitiesForTheDay(_ today: Date) -> [ActivityModel] {
        
        let settings = getSettings()
        var activities:[ActivityModel] = []
        
        for setting in settings {
            if (setting.isEnabled) {
                if (setting.activityId == 1) {
                    activities.append(contentsOf: calculateSleep(today: today))
                }
                if (setting.activityId == 3) {
                    activities.append(contentsOf: calculateRun(today: today))
                }
                if (setting.activityId == 4) {
                    activities.append(contentsOf: calculateDrive(today: today))
                }
            }
        }
        return activities
    }
    
    func calculateSleep(today: Date) -> [ActivityModel] {
        let sleep:[ActivityModel] = []
        return sleep
    }
       
    func calculateRun(today: Date) -> [ActivityModel] {
        return calculate(today, ActivityType.Run, 1)
    }

    func calculateDrive(today: Date) -> [ActivityModel] {
        return calculate(today, ActivityType.Drive, 2)
    }
    
    func calculate(_ today: Date, _ activity: ActivityType, _ max: Int) -> [ActivityModel] {
        var drive:[ActivityModel] = []
        
        
        //1. Layer 1: Isolate the activity type
        let layer1  =  getMotionDataAll().filter { $0.activityId == activity.rawValue && Calendar.current.component(.day, from: $0.start) == Calendar.current.component(.day, from: today) }
        
        //2. Layer 2: Sort data by time
        let layer2 = layer1.sorted(by: { Calendar.current.component(.hour, from: $0.start) > Calendar.current.component(.hour, from: $1.start)  } )
        
        //3. Layer 3: Group rows by hour and count
        var dictionary = [Int: Int]()
        
        for item in layer2 {
            let key = Calendar.current.component(.hour, from: item.start)
            if let currentValue = dictionary[key] {
                // we have seen this name before, add to its value
                dictionary[key] = currentValue + 1
            }
            else {
                // we haven't seen this name, add it to the dictionary
                dictionary[key] = 1
            }
        }
        //sort the dictionary
        let top = Array(dictionary).sorted {$0.1 > $1.1}
        
        
        //4. Layer 4: Get top 2 occurances
        let date = NSDate()
        
        //create calendar object
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local
        
        //Get components using current Local & Timezone
        var component = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date)
        
        for item in top.prefix(max) {
            component.hour = item.1
            let activity = ActivityModel(activityName: activity.description, datestart: calendar.date(from: component)!, location: "", steps: 0)
            drive.append(activity)
        }
        
        return drive
    }
    
    func isEnabled(_ activity: ActivityType) -> Bool {
        let settings = self.getSettings()
        
        if let setting = settings.first(where: { $0.activityId == activity.rawValue }) {
            return setting.isEnabled
        }
        return false
    }
}
