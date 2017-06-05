//
//  RawDataModel.swift
//  Mahadevan_K_IntelligentAssistant
//
//  Created by Krishnan Mahadevan on 6/4/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation

struct MotionDataModel {
    var activityId: Int16
    var activityName: String
    var start: Date
    var location: (Float, Float)
    var steps: Int32
}
