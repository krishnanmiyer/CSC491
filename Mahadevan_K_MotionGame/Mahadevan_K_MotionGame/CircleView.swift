//
//  CircleView.swift
//  Mahadevan_K_MotionGame
//
//  Created by Krishnan Mahadevan on 5/4/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import UIKit

class CircleView: GameObject {
    
    var circle = UIView()
    var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        resetCircle()
        addSubview(circle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetCircle() {
        
        var rectSide: CGFloat = 0
        if (frame.size.width > frame.size.height) {
            rectSide = frame.size.height
        } else {
            rectSide = frame.size.width
        }
        
        let circleRect = CGRect(x: (frame.size.width-rectSide)/2, y: (frame.size.height-rectSide)/2, width: rectSide, height: rectSide)
        circle = UIView(frame: circleRect)
        circle.backgroundColor = UIColor.orange
        circle.layer.cornerRadius = rectSide/2
        circle.layer.borderWidth = 1.0
        circle.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func resizeCircle (summand: CGFloat) {
        
        frame.origin.x -= summand/2
        frame.origin.y -= summand/2
        
        frame.size.height += summand
        frame.size.width += summand
        
        circle.frame.size.height += summand
        circle.frame.size.width += summand
    }
    
    func moveCircle(x: CGFloat, y: CGFloat) {
        frame.origin.x = x
        frame.origin.y = y
        circle.setNeedsDisplay()
        self.setNeedsDisplay()
    }
    
    public var x: CGFloat {
        get {
            return frame.origin.x;
        }
    }

    public var y: CGFloat {
        get {
            return frame.origin.y;
        }
    }
    
    override func accept(visitor other: IVisitor ) {
        other.visitCircle(circle: self)
    }
    
    override func visitCircle(circle: CircleView) {
        print("Collided with  Circle - 1")
    }
    
    override func visitBlock(block: BlockView) {
        print("Collided with Circle - 2")
        ScoreBoard.sharedInstance.score += block.tag
        block.removeFromSuperview()
    }
}
