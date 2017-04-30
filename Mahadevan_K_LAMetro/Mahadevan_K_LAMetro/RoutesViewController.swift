//
//  RoutesController.swift
//  Mahadevan_K_LAMetro
//
//  Created by Krishnan Mahadevan on 4/29/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit

class RoutesViewController: UITableViewController {
    
    var routes:[RouteModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.routes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "route", for: indexPath)
        
        cell.textLabel?.text = routes[indexPath.row].displayName
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? StopsViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                detail.route = routes[indexPath.row]
            }
        }
    }
    
    private func loadData() {
        MetroService.getRoutes() { routeData in
            DispatchQueue.main.async {
                self.routes = routeData
                self.tableView.reloadData()
            }
        }
    }
}
