//
//  ScoreManager.swift
//  Mahadevan_K_MotionGame
//
//  Created by Krishnan Mahadevan on 5/15/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation

class ScoreBoard {
    static let sharedInstance = ScoreBoard()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    public var score:Int = 0
}
