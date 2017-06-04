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
