//
//  ViewController.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/14/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var segElements: UISegmentedControl!
    @IBOutlet weak var segSortType1: UISegmentedControl!
    @IBOutlet weak var segSortType2: UISegmentedControl!
    @IBOutlet weak var vwGraph1: UIView!
    @IBOutlet weak var vwGraph2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let k = BarFactory.getBar(color: UIColor.blue)
        
        // Add the view to the view hierarchy so that it shows up on screen
        self.view.addSubview(k)
        
        let j = BarFactory.getBar(color: UIColor.yellow)
        j.x = j.x + 100.0
        // Add the view to the view hierarchy so that it shows up on screen
        self.view.addSubview(j)

        let i = BarFactory.getBar(color: UIColor.blue)
        i.x = i.x + 200.0
        // Add the view to the view hierarchy so that it shows up on screen
        self.view.addSubview(i)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnSortClick(_ sender: Any) {
        //TODO: Start Sort
    }

    
    
}

