//
//  ViewController.swift
//  Mahadevan_K_LAMetro
//
//  Created by Krishnan Mahadevan on 4/23/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit


class RealTimeViewController: UITableViewController {
    
    @IBOutlet weak var map: UIImageView!
    
    var stop:StopModel!
    var records:[RealTimeModel] = []
    var dataAvailable:Bool =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Realtime Status"
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.loadData), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async {
            self.loadMapImage()
        }
        queue.async {
            self.loadData()
        }
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
        return dataAvailable ? self.records.count : 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataAvailable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "realtime", for: indexPath)
            cell.textLabel?.text = "Bus Route: \(records[indexPath.row].routeId)"
        
            if (records.count < 1) {
                cell.detailTextLabel?.text = "Data unavailable...!"
            }
            
            if (records[indexPath.row].seconds > 59) {
                cell.detailTextLabel?.text = "...arrives in \(Int(records[indexPath.row].minutes)) minute(s)"
            }
            else {
                cell.detailTextLabel?.text = "...arrives in \(Int(records[indexPath.row].seconds)) second(s)"
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeholder", for: indexPath)
            cell.textLabel?.text = "Loading..."
            return cell
        }
    }
    
    @objc private func loadData() {       
        MetroService.getRealTime(self.stop.id) { realTimeData in
            DispatchQueue.main.async {
                self.records = realTimeData
                self.dataAvailable = true
                self.tableView.reloadData()
            }
        }
    }
    
    func loadMapImage() {
        MetroService.getMapImage(self.stop.location.latitude, self.stop.location.longitude, self.stop.displayName, Int(self.map.frame.width), Int(self.map.frame.height)) { mapImage in
            DispatchQueue.main.async {
                self.map.image = mapImage
            }
        }
    }
}
