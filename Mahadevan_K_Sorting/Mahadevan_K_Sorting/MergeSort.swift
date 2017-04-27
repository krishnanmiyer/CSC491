//
//  MergeSort.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/16/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
public struct MergeSort: SortStrategy {
    
    func sort(_ elements:[Int]) -> [Int] {
        return sortCallBack(elements)
    }
    
    func sort(_ elements:[Int], _ callback: @escaping (Int, Int) -> ()) -> [Int] {
        return sortCallBack(elements, callback)
    }
    
    private func sortCallBack(_ a: [Int], _ callback: ((Int, Int) -> ())? = nil) -> [Int] {
        return mergeSort(a, callback)
    }
    
    func merge(left:[Int],right:[Int], _ callback: ((Int, Int) -> ())? = nil) -> [Int] {
        var mergedList = [Int]()
        var left = left
        var right = right
        
        while left.count > 0 && right.count > 0 {
            if left.first! < right.first! {
                mergedList.append(left.removeFirst())
            } else {
                mergedList.append(right.removeFirst())
            }
        }
        
        let merged = mergedList + left + right
        if callback != nil {
            for i in 0 ..< merged.count - 1 {
                DispatchQueue.main.async {
                    callback!(i, merged[i])
                }
                usleep(10000)
            }
        }
        return merged;
    }
    
    func mergeSort(_ list:[Int], _ callback: ((Int, Int) -> ())? = nil) -> [Int] {
        guard list.count > 1 else {
            return list
        }
        
        let leftList = Array(list[0..<list.count/2])
        let rightList = Array(list[list.count/2..<list.count])
        
        return merge(left: mergeSort(leftList), right: mergeSort(rightList), callback)
    }
}
