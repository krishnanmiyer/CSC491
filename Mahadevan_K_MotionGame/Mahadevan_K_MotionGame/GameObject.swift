//
//  GameObject.swift
//  Mahadevan_K_MotionGame
//
//  Created by Krishnan Mahadevan on 5/15/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import UIKit

class GameObject: UIView, ICollidable, IVisitor {

    func accept(visitor other: IVisitor ) {
    
    }
    
    func visitCircle(circle: CircleView) {
    
    }
    
    func visitBlock(block: BlockView) {

    }
}
