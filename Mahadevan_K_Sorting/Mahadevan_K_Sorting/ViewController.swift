//
//  ViewController.swift
//  Mahadevan_K_Sorting
//
//  Created by Krishnan Mahadevan on 4/10/17.
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
    
    var graph1:GraphManager!
    var graph2:GraphManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //instantiate graph managers
        graph1 = GraphManager(container: vwGraph1, graphColor: UIColor.green)
        graph2 = GraphManager(container: vwGraph2, graphColor: UIColor.brown)
        
        //initiate shuffled graph
        
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnSortClick(_ sender: Any) {
        
        //initiate thread to execute sort
        
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            let sortType = SortFactory.getSortStrategy(self.segSortType1.selectedSegmentIndex)
            self.graph1.sort(sortType)
        }
        queue.async {
            let sortType = SortFactory.getSortStrategy(self.segSortType2.selectedSegmentIndex)
            self.graph2.sort(sortType)
        }
    }

    @IBAction func segElementsValueChanged(_ sender: UISegmentedControl) {
        if let selected = sender.titleForSegment(at: sender.selectedSegmentIndex) {
            graphInit(Int(selected)!)
        }
    }
    
    private func graphInit(_ selected: Int) {
        graph1.drawGraph(selected)
        graph2.drawGraph(selected)
    }
}
