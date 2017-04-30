//
//  StopsViewController.swift
//  Mahadevan_K_LAMetro
//
//  Created by Krishnan Mahadevan on 4/29/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit

class StopsViewController: UITableViewController {

    var route: RouteModel!
    var stops: [StopModel] = []
    var dataAvailable:Bool =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataAvailable ? stops.count : 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataAvailable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stop", for: indexPath)
            cell.textLabel?.text = stops[indexPath.row].displayName
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeholder", for: indexPath)
            cell.textLabel?.text = "Loding..."
            return cell
        }
    }

    private func loadData() {
        self.title = route.displayName
        MetroService.getStops(route.id) { stopsData in
            DispatchQueue.main.async {
                self.stops = stopsData
                self.dataAvailable = true
                self.tableView.reloadData()
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? RealTimeViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                detail.stop = stops[indexPath.row]
            }
        }
    }
}
