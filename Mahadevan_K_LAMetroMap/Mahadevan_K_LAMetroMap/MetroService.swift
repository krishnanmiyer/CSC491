//
//  MetroService.swift
//  Mahadevan_K_LAMetro
//
//  Created by Krishnan Mahadevan on 4/24/17.
//  varyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import SwiftyJSON

public class MetroService {
    
    static var allRoutes:[RouteModel] = []

    static var allStops:[StopModel] = []
    
    private static let maxDistance = 10.00
    
    /**
     Returns Metro Bus Routes from LA Metro API Service.

     - returns: An Array of RoutModel instance.
     */
    public static func getRoutes(completion: @escaping ([RouteModel]) -> Void) {
        var routes:[RouteModel] = []
        let feed:String = "http://api.metro.net/agencies/lametro/routes/"
        
        guard let feedUrl = URL(string: feed) else { return}
        
        let request = URLRequest(url: feedUrl)
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = JSON(data: data)
                for (_, e) in json["items"] {
                    if let id = e["id"].string,
                        let name = e["display_name"].string {
                        
                        if let route =  RouteModel(Int(id)!, name) {
                            routes.append(route)
                        }
                    }
                }
            }
            completion(routes)
            }.resume()
    }

    /**
     Returns Metro Bus Stops in sequence for a Route from LA Metro API Service.
     
     - parameter routeId:  Int Route identifier.
     
     - returns: An Array of RoutModel instance.
     */
    public static func getStops(_ routeId: Int, completion: @escaping ([StopModel]) -> Void) {
        var stops:[StopModel] = []
        
        let feed:String = "http://api.metro.net/agencies/lametro/routes/\(routeId)/stops/"
        guard let feedUrl = URL(string: feed) else { return }
        
        let request = URLRequest(url: feedUrl)
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = JSON(data: data)
                for (_, e) in json["items"] {
                    if let id = e["id"].string,
                        let name = e["display_name"].string ,
                        let latitude = e["latitude"].double,
                        let longitude = e["longitude"].double {
                        
                        if var stop = StopModel() {
                            stop.id = Int(id)!
                            stop.displayName = name
                            stop.location = (latitude, longitude)
                            stops.append(stop)
                        }
                    }
                }
            }
            completion(stops)
            }.resume()
    }
    
    /**
     Returns Real time status of buses for a Stop.
     
     - parameter stopId:  Int Stop identifier.
     
     - returns: An Array of RealTimeModel instance.
     */
    public static func getRealTime(_ stopId: Int, completion: @escaping ([RealTimeModel]) -> Void) {
        var rtdata:[RealTimeModel] = []
        
        let feed:String = "http://api.metro.net/agencies/lametro/stops/\(stopId)/predictions/"
        guard let feedUrl = URL(string: feed) else { return }
        
        let request = URLRequest(url: feedUrl)
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = JSON(data: data)
                for (_, e) in json["items"] {
                    if let blockId = e["block_id"].string,
                        let runId = e["run_id"].string ,
                        let seconds = e["seconds"].double,
                        let isDeparting = e["is_departing"].bool,
                        let routeId = e["route_id"].string ,
                        let minutes = e["minutes"].double {
                        
                        if var rt = RealTimeModel() {
                            rt.blockId = Int(blockId)!
                            rt.runId = runId
                            rt.seconds = seconds
                            rt.isDeparting = isDeparting
                            rt.routeId = Int(routeId)!
                            rt.minutes = minutes
                            rtdata.append(rt)
                        }
                    }
                }
            }
            completion(rtdata)
            }.resume()
    }
    
    /**
     Returns map image with markers from Google Static image service.
     
     - parameter latitude:  Double location latitude.
     - parameter longitude:  Double location longitude.
     - parameter label:  String Label of the bus stop.
     - parameter width:  Int Image Width.
     - parameter height:  Int Image Height.
     
     - returns: UIImage object.
     */
    public static func getMapImage(_ latitude:Double, _ longitude:Double, _ label: String, _ width: Int, _ height: Int, completion: @escaping (UIImage) -> Void) {

        let googleapiKey="AIzaSyBZRkS2PrPrhX3J2kSjhrMf99llgB1fyWE"
        var mapImage:UIImage!
        
        let feed: String = "https://maps.googleapis.com/maps/api/staticmap?center=\(latitude),\(longitude)&zoom=16&size=\(width + 100)x\(height + 100)&markers=color:blue|label:\(label)|\(latitude),\(longitude)&key=\(googleapiKey)"
        
        guard let feedUrl = URL(string: feed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        let request = URLRequest(url: feedUrl)
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            guard let imageData = data else { return }
            
            do {
                mapImage = UIImage(data: imageData)
            }
            completion(mapImage)
        }.resume()
    }
}

extension Double {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
