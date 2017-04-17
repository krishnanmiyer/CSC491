//
//  BarManager.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/10/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import UIKit

/*
 Manages the bars in the graph. Uses concept of object pool for effective memory management
 implements prototype pattern
*/

public class BarManager {
    
    //Reserve pools holds bar object in reserve
    private var _reserve:Set<Bar> = Set<Bar>();
    
    //Active pool holds bar object that are in-use in the view
    private var _active:Set<Bar> = Set<Bar>();
    
    /**
     Constructor
     
     @param poolSize set pool size for each graph
     
     @return none
     */
    init(_ poolSize: Int) {
        
        //populate reserve object pool
        for _ in 0 ... poolSize  {
            let bar = Bar(frame: CGRect(origin: CGPoint(x: 0, y: 50),size: CGSize(width: 30, height: 20)))
            _reserve.insert(bar);
        }
    }
    
    
    /**
     returns bar object from reserve pool. implements prototype pattern to reuse objects
     
     @param color: bar color
     
     @return bar object
     */
    internal func getBar(color: UIColor) -> Bar {
        //fetch bar from reserce
        let bar = _reserve.first ?? Bar()
        
        //apply desired color
        bar.color = color;
        
        //add it to the active pool of objects
        _active.insert(bar)
        
        //remove from reserve pool
        _reserve.removeFirst();
        
        //return the new object
        return bar;
    }
    
    
    /**
     clears the active pool and sends all objects back to the reserve pool
     
     @param bar Consectetur adipisicing elit.
     
     */
    internal func reset() {
        //reset all objects to default
        for bar in _active  {
            bar.color = UIColor.brown
            _reserve.insert(bar);
        }
        
        _active.removeAll()
    }
}
