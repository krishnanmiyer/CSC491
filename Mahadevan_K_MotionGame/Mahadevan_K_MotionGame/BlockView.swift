//
//  Block.swift
//  Mahadevan_K_MotionGame
//
//  Created by Krishnan Mahadevan on 5/7/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import UIKit

class BlockView: GameObject {

    override func accept(visitor other: IVisitor ) {
        other.visitBlock(block: self)
    }
    
    override func visitCircle(circle: CircleView) {
        print("Collided with Block")
    }
    
    override func visitBlock(block: BlockView) {
        print("Collided with Block")
    }
}
