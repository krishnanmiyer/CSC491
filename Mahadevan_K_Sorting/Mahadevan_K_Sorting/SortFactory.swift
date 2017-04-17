//
//  SortFactory.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/12/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation

/**
 
 Implements Factory pattern to return a particular sort object
 
 */


public class SortFactory {
    internal static func getSortStrategy(_ order: Int) -> SortStrategy {
        switch(order) {
        case 0:
            return InsertionSort()
        case 1:
            return SelectionSort()
        case 2:
            return QuickSort()
        case 3:
            return MergeSort()
        default:
            return InsertionSort()
        }
    }
}
