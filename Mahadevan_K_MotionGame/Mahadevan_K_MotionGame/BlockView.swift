//
//  BlockView.swift
//  Mahadevan_K_MotionGame
//
//  Created by Krishnan Mahadevan on 5/14/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import UIKit

class BlockView: UIView {
    var block = UIView()
    var isAnimating = false
    
    var blockType: Block = Block.Angel
    
    public enum Block: String {
        case Angel
        case Beast
    }
    
    public var BlockType: Block {
        get {
            return blockType
        }
        set {
            blockType = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        resetBlock()
        addSubview(block)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetBlock() {
        
        var rectSide: CGFloat = 0
        if (frame.size.width > frame.size.height) {
            rectSide = frame.size.height
        } else {
            rectSide = frame.size.width
        }
        
        let blockRect = CGRect(x: (frame.size.width-rectSide)/2, y: (frame.size.height-rectSide)/2, width: rectSide, height: rectSide)
        block = UIView(frame: blockRect)
        block.backgroundColor = blockType == Block.Angel ? UIColor.green : UIColor.red
        block.layer.borderWidth = 1.0
        block.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    func moveBlock(x: CGFloat, y: CGFloat) {
        frame.origin.x = x
        frame.origin.y = y
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
  
}
