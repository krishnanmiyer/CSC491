//
//  GraphManager.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/15/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import GameKit

internal class GraphManager {
    
    private func getElements(_ count: Int) -> [Int] {
        var elements:[Int] = [count]
        
        for i in 0 ..< count - 1 {
            elements[i] = i + 1
        }
        
        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: elements) as! [Int]
        
        return shuffled
    }
    
    
    public func DrawGraph (_ count: Int) {
        
    
    
    }


    
}
