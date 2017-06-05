//
//  DataService.swift
//  Mahadevan_K_IntelligentAssistant
//
//  Created by Krishnan Mahadevan on 6/4/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataService {
    
    static func getSettings() -> [UserSetting] {
        
        let context = getContext()
        
        var settings: [UserSetting] = []
        
        do {
            settings = try context.fetch(UserSetting.fetchRequest())
            return settings
        } catch {
            print("Fetching activities failed")
        }
        return settings
    }
    
    static func getMotionData() -> [MotionData] {
        let context = getContext()
        
        var motionData: [MotionData] = []
        
        do {
            motionData = try context.fetch(MotionData.fetchRequest())
            return motionData
        } catch {
            print("Fetching activities failed")
        }
        return motionData
    }
    
    static func getMotionData(activityId: Int16, today: Date) -> [MotionData] {
        //Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: today) // eg. 2016-10-10 00:00:00
        let predicate = NSPredicate(format: "activityId = %@ AND start <= %@", activityId as CVarArg, dateFrom as CVarArg)
        let request = NSFetchRequest<MotionData>(entityName: "MotionData")
        request.predicate = predicate
        
        var motions:[MotionData] = []
        
        do {
            let context = getContext()
            motions =  try context.fetch(request)
            return motions
            
        } catch let error as NSError {
            print("Could fetch motion data for the day. \(error), \(error.userInfo)")
        }
        return motions
    }
    
    
    static func saveSetting(activityId: Int16, enabled: Bool) {
        
        let context = getContext()
        let predicate = NSPredicate(format: "activityId == %d", activityId)
        let request = NSFetchRequest<UserSetting>(entityName: "UserSetting")
        request.predicate = predicate
        
        do {
            let results =  try context.fetch(request)
            
            if results.count > 0  {
                if let profile = results.first {
                    profile.setValue(enabled, forKeyPath: "enabled")
                }
            }
            else {
                let entity =  NSEntityDescription.entity(forEntityName: "UserSetting", in: context)!
                let profile = NSManagedObject(entity: entity, insertInto: context)
                profile.setValue(activityId, forKeyPath: "activityId")
                profile.setValue(enabled, forKeyPath: "enabled")
            }
            try context.save()
        } catch let error as NSError {
            print("Could not save User Setting. \(error), \(error.userInfo)")
        }
    }

    static func saveMotionData(activityId: Int16, start: Date, latitude: Float, longitude: Float, steps: Int32) {
       
        do {
            let context = getContext()

            let entity =  NSEntityDescription.entity(forEntityName: "MotionData", in: context)!
            let profile = NSManagedObject(entity: entity, insertInto: context)
            profile.setValue(activityId, forKeyPath: "activityId")
            profile.setValue(start, forKeyPath: "start")
            profile.setValue(latitude, forKeyPath: "latitude")
            profile.setValue(longitude, forKeyPath: "longitude")
            profile.setValue(steps, forKeyPath: "steps")

            try context.save()
        } catch let error as NSError {
            print("Could not save Motion Data. \(error), \(error.userInfo)")
        }
    }
    
    static func deleteArchives() {
        //Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        let predicate = NSPredicate(format: "start <= %@", dateFrom as CVarArg)
        let request = NSFetchRequest<MotionData>(entityName: "MotionData")
        request.predicate = predicate
        
        do {
            let context = getContext()
            let result =  try context.fetch(request)
            
            if result.count > 0 {
                for object in result {
                    print(object)
                    context.delete(object as NSManagedObject)
                }
            }
        } catch let error as NSError {
            print("Unable to delete archive data. \(error), \(error.userInfo)")
        }
    }
    
    private static func getContext () -> NSManagedObjectContext {
        let appDelegate = getAppDelegate()
        return appDelegate.persistentContainer.viewContext
    }
    
    private static func getAppDelegate () -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
}
