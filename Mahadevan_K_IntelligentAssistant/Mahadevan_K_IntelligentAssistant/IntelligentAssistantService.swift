//
//  IntelligentAssistantService.swift
//  Mahadevan_K_IntelligentAssistant
//
//  Created by Krishnan Mahadevan on 5/20/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation

class IntelligentAssistantService {

    func getSettings() -> [SettingsModel] {
        
        let activities = DataService.getActivities()
        let userSettings = DataService.getSettings()
        
        var settings:[SettingsModel] = []
        
        for userSetting in userSettings {
            let activity = activities.first(where: { $0.activityId == userSetting.activityId })
            
            let setting = SettingsModel(activityName:(activity?.activityDesc)!,
                                        isEnabled: userSetting.enabled,
                                        activityId: userSetting.activityId)
            settings.append(setting)
        }
        return settings
    }
    
    func saveSettings(activityId: Int16, status: Bool) -> Void {
        DataService.saveSetting(activityId: activityId, enabled: status)
    }
    
    func getMotionDataAll() -> [MotionDataModel] {
        
        let activities = DataService.getActivities()
        let data = DataService.getMotionData()
        
        var motions:[MotionDataModel] = []
        
        for rec in data {
            let activity = activities.first(where: { $0.activityId == rec.activityId })
            
            let motion = MotionDataModel(activityId: rec.activityId
                , activityName: (activity?.activityDesc)!
                , start: rec.start! as Date
                , end: rec.end! as Date
                , location: (rec.latitude, rec.longitude))
            
            motions.append(motion)
        }
        return motions
    }
    
    func saveMotionData(motion: MotionDataModel) {
        DataService.saveActivity(activityId: motion.activityId, start: motion.start, end: motion.end, latitude: motion.location.0, longitude: motion.location.1)
    }
    
    func cleanUpMotionData() {
        DataService.deleteArchives()
    }
    
    func getActivitiesForTheDay(today: Date) -> [ActivityModel] {
        
        let settings = getSettings()
        var activities:[ActivityModel] = []
        
        for setting in settings {
            if (setting.isEnabled) {
                if (setting.activityId == 1) {
                    activities.append(contentsOf: calculateSleep(today: today))
                }
                if (setting.activityId == 2) {
                    activities.append(contentsOf: calculateWalk(today: today))
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
    
    func calculateWalk(today: Date) -> [ActivityModel] {
        let walk:[ActivityModel] = []
        return walk
    }
    
    func calculateRun(today: Date) -> [ActivityModel] {
        let run:[ActivityModel] = []
        return run
    }
    
    func calculateDrive(today: Date) -> [ActivityModel] {
        let drive:[ActivityModel] = []
        return drive
    }

}
