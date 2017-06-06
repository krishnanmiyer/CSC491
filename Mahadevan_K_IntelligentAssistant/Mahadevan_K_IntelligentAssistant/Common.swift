//
//  DateUtil.swift
//  Mahadevan_K_IntelligentAssistant
//
//  Created by Krishnan Mahadevan on 6/2/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b as Date) == ComparisonResult.orderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b as Date) == ComparisonResult.orderedSame
}

extension NSDate: Comparable { }

enum ActivityType: Int16{
    case Sleep = 1, Walk = 2, Run = 3, Drive = 4
    var description: String {
        get { return String(describing: self) }
    }
}

extension Dictionary where Value:Comparable {
    var sortedByValue:[(Key,Value)] {return Array(self).sorted{$0.1 < $1.1}}
}
extension Dictionary where Key:Comparable {
    var sortedByKey:[(Key,Value)] {return Array(self).sorted{$0.0 < $1.0}}
}
