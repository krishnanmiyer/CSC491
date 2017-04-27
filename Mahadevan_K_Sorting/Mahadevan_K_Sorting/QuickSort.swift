//
//  QuickSort.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/16/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
public struct QuickSort: SortStrategy {
    
    func sort(_ elements:[Int]) -> [Int] {
        return sortCallBack(elements)
    }
    
    func sort(_ elements:[Int], _ callback: @escaping (Int, Int) -> ()) -> [Int] {
        return sortCallBack(elements, callback)
    }
    
    private func sortCallBack(_ a: [Int], _ callback: ((Int, Int) -> ())? = nil) -> [Int] {
        var z = a
        quicksort( &z, 0, a.count - 1, callback)
        return z
    }
    
    func quicksort(_ a:inout [Int], _ start:Int, _ end:Int, _ callback: ((Int, Int) -> ())? = nil) {
        if (end - start < 2){
            return
        }
        let p = a[start + (end - start)/2]
        var l = start
        var r = end - 1
        while (l <= r){
            if (a[l] < p){
                l += 1
                continue
            }
            if (a[r] > p){
                r -= 1
                continue
            }
            let t = a[l]
            
            a[l] = a[r]
            a[r] = t

            let lvalue = a[l]
            let rvalue = a[r]
            
            if callback != nil {
                DispatchQueue.main.async {
                    callback!(l, lvalue)
                    callback!(r, rvalue)
                }
                usleep(15000)
            }
            
            l += 1
            r -= 1
        }
        quicksort(&a, start, r + 1, callback)
        quicksort(&a, r + 1, end, callback)
    }
}
