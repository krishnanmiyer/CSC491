//
//  SortStrategy.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/16/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation

/**
 Implements Stategry pattern to implement various Sort Strategies
 */

protocol SortStrategy {
    func sort(_ elements:[Int]) -> [Int]
    func sort(_ elements:[Int], _ callback: @escaping (Int, Int) -> ()) -> [Int]
}
	
