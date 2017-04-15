//
//  Bar.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/14/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit

internal class Bar: UIView {

    private var _color: UIColor = UIColor.green
    private var _height:Float = 0.0
    private var _width:Float = 0.0
    private var _x: Float = 0.0
    private var _y: Float = 0.0
   
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        _x = Float(frame.origin.x)
        _y = Float(frame.origin.y)
        _width = Float(frame.width)
        _height = Float(frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        _color.set()
        UIRectFill(rect)
    }
    
    public func update() {
        self.frame.size = CGSize(width: CGFloat(_width), height: CGFloat(_height))
        self.frame.origin = CGPoint(x: CGFloat(_x), y: CGFloat(_y))
        self.setNeedsDisplay()
    }
    
    public var height:Float {
        get {
            return self._height
        }
        set {
            self._height = newValue
            update()
        }
    }
    
    public var width:Float {
        get {
            return self._width
        }
        set {
            self._width = newValue
            update()
        }
    }

    public var x:Float {
        get {
            return self._x
        }
        set {
            self._x = newValue
            update()
        }
    }
    
    public var y:Float {
        get {
            return self._y
        }
        set {
            self._y = newValue
            update()
        }
    }

    public var color :UIColor {
        get {
            return self._color
        }
        set {
            self._color = newValue
            self.setNeedsDisplay()
        }
    }
}
