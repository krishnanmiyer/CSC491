//
//  InsertionSort.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/16/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation

public struct InsertionSort: SortStrategy {
    
    func sort(_ elements:[Int]) -> [Int] {
        return sortCallBack(elements)
    }
    
    func sort(_ elements:[Int], _ callback: @escaping (Int, Int) -> ()) -> [Int] {
        return sortCallBack(elements, callback)
    }
    
    private func sortCallBack(_ a: [Int], _ callback: ((Int, Int) -> ())? = nil) -> [Int] {
        guard a.count > 1 else { return a }
        
        var b = a
        for i in 1..<b.count {
            var y = i
            let temp = b[y]
            while y > 0 && temp < b[y - 1] {
                b[y] = b[y - 1]
                
                if callback != nil {
                    DispatchQueue.main.async {
                        callback!(y - 1, b[y])
                    }
                    usleep(150000)
                }
                y -= 1
            }
            b[y] = temp
            
        }
        return b
    }
}
