//
//  GraphManager.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/15/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import GameKit

/**
 
 Manages the graph in the view. Each view must initiate the graph manager to implement a graph
 
 */

internal class GraphManager {
    
    private var _container: UIView!
    private var _elements:[Int] = [Int]()
    private var _bars:[Bar] = [Bar]()
    private var _barManager: BarManager!
    private let poolSize: Int = 64
    private var _color: UIColor
    
    
    /**
     
     constructor to Graph Manager
     
     @param container: UIView that holds the graph
     
     @param color: Graph color
     
     */
    public init(container: UIView, graphColor color: UIColor) {
        _container = container;
        _barManager = BarManager(poolSize)
        _color = color
    }

    /**
     Performs Sorting depending upon Sort Strategry. Implements Strategry pattern for sorting
     
     @param sortStrategry.
     
     */
    
    public func sort(_ sortStrategy: SortStrategy) {
        let result = sortStrategy.sort(_elements, updateBar)
        print(result)
    }
    
    /**
     Gets an array of data elements
     
     @param count: Number of items
     
     @return array of int
     */
    private func getElements(_ count: Int) -> [Int] {
        var elements:[Int] = [count]
        
        //Populate the array
        for i in 0 ..< count {
            elements.append(((i + 1) * 2) + 30)
        }
        
        //Shuffle the array
        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: elements) as! [Int]
        return shuffled
    }

    /**
     Gets an array of Bar object
     
     @param count: Number of items
     
     @return array of Bar
     */
    private func getBars (_ count: Int) -> [Bar] {
        var bars:[Bar] = [Bar]()
        
        for _ in 1...count {
            let bar = _barManager.getBar(color: _color)
            bars.append(bar)
        }
        
        return bars
    }
    
    /**
     Sets the bar object parameters the draws the object on the view
     
     @param dataSize: Number of item
     
     */
    public func drawGraph(_ dataSize: Int) {
        //reset all elements
        reset()
        
        //get elements and shuffle them
        _elements = getElements(dataSize)
        
        //get bars and size them
        _bars = getBars(dataSize)
        
        //add view to the container
        let maxWidth:Int = Int(_container.frame.width) - 8 //max graph width
        let gapSize:Int = 1 //space between the graph
        let startAt:Int = 8
        let barWidth = (maxWidth - (gapSize * dataSize)) / dataSize
        var x:Int = startAt
        let y:Int = Int(_container.frame.height) - 8
        
        for i in 0 ..< _bars.count {
            let bar = _bars[i]
            bar.height = CFloat(_elements[i])
            bar.width = CFloat(barWidth)
            bar.x = CFloat(x)
            bar.y = CFloat(y - _elements[i])
            bar.tag = 1234
            x = x + barWidth + gapSize
            _container.addSubview(bar)
        }
        _container.setNeedsDisplay()
    }
    
    /**
 
     Rests all objects in the class
     
    */
    private func reset() {
        //removes bar from super view
        for sub in _container.subviews {
            if sub.tag > 0 {
                sub.removeFromSuperview()
            }
        }
        
        //clear bars collection
        _bars.removeAll()
        
        //clear data collection
        _elements.removeAll()
        
        //clear active pool
        _barManager.reset()
    }
    
    /**
     
     Call back method to update graph when Sort is in progress
     
     */
    public func updateBar(_ index: Int, _ value: Int) {
        let y:Int = Int(_container.frame.height) - 8
        let bar = _bars[index]
        bar.height = Float(value)
        bar.y = Float(y - value)
    }
}
