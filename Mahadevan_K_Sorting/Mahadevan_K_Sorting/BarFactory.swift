//
//  BarManager.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/15/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import UIKit

public class BarFactory {
    private static var shapes:Set<Bar> = Set<Bar>();
    
    internal static func getBar(color: UIColor) -> Bar {
        //let exists = shapes.contains(where: { $0.color == color})
        
        //if (!exists) {
            let bar = Bar(frame: CGRect(origin: CGPoint(x: 50, y: 50),size: CGSize(width: 100, height: 100)))
            bar.color = color;
            //shapes.insert(bar);
            return bar;
        //}
        //return shapes.first(where: { $0.color == color})!
    }
}
