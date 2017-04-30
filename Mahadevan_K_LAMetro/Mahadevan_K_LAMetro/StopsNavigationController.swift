//
//  StopsNavigationController.swift
//  Mahadevan_K_LAMetro
//
//  Created by Krishnan Mahadevan on 4/30/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit

class StopsNavigationController: UINavigationController {

    var route: RouteModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for let i 0 ..< self.childViewControllers.count {
        print("childrens: ", self.childViewControllers.count)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
