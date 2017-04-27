//
//  SelectionSort.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/16/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
public struct SelectionSort: SortStrategy {
    
    func sort(_ elements:[Int]) -> [Int] {
        return sortCallBack(elements)
    }
    
    func sort(_ elements:[Int], _ callback: @escaping (Int, Int) -> ()) -> [Int] {
        return sortCallBack(elements, callback)
    }
    
    private func sortCallBack(_ a: [Int], _ callback: ((Int, Int) -> ())? = nil) -> [Int] {
        guard a.count > 1 else { return a }
        
        var z = a
        
        for x in 0 ..< a.count - 1 {
            var lowest = x
            for y in x + 1 ..< a.count {
                if z[y] < z[lowest] {
                    lowest = y
                }
            }
            
            if x != lowest {
                swap(&z[x], &z[lowest])
            }
            
            if callback != nil {
                DispatchQueue.main.async {
                    callback!(x, z[x])
                }
                usleep(15000)
            }
        }
        return z
    }
}
