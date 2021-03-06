//
//  ICollidable.swift
//  Mahadevan_K_MotionGame
//
//  Created by Krishnan Mahadevan on 5/15/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation

protocol ICollidable {
    func accept(visitor: IVisitor)
}
