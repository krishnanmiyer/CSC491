//
//  LocateMeController.swift
//  Mahadevan_K_LAMetroMap
//
//  Created by Krishnan Mahadevan on 5/21/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocateMeController: UIViewController, LocationServiceDelegate {

    @IBOutlet weak var mapMessages: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var stops:[StopModel] = []
    let maxDistance = 2.00
    private var applied = CLLocationCoordinate2D()
    var dataAvailable = false
    var maxData:Int = 20666
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (MetroService.allStops.count > 1) {
            stops = MetroService.allStops
            dataAvailable = true
        }
        else {
            preLoadStops()
        }
        LocationService.sharedInstance.delegate = self
        mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LocationService.sharedInstance.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LocationService.sharedInstance.stopUpdatingLocation()
    }

    private func preLoadStops() {
        mapMessages.text = "Loading data..."
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        queue.async {
            for route in MetroService.allRoutes {
                MetroService.getStops(route.id) { stopsData in
                    self.stops.append(contentsOf: stopsData)
                    
                    if (self.stops.count >= self.maxData) {
                        queue.async {
                            MetroService.allStops.append(contentsOf: self.stops)
                            self.updatePins(self.applied.latitude, self.applied.longitude)
                        }
                    }
                }
            }
        }
    }
    
    func traceLocation(currentLocation: CLLocation) {
        if (applied.latitude == 0 && applied.longitude == 0) {
            applied = currentLocation.coordinate
        }
        else {
            let distance = computeDistance(currentLocation.coordinate.latitude, currentLocation.coordinate.latitude, applied.latitude, applied.longitude)
            
            //minimum distance when map has to be updated
            if distance < 10000 {
                return
            }
            
            if (dataAvailable) {
                updatePins(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            }
        }
        mapView.setRegion(MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
    }
    
    func traceLocationError(error: Error) {
        print(error)
    }

    private func updatePins(_ lat: Double, _ lng: Double) {

        let closest:[StopModel] = getClosestStops(lat, lng)

        DispatchQueue.main.async {
            self.mapMessages.text = "Updating pins"
            
            for annotation in self.mapView.annotations {
                self.mapView.removeAnnotation(annotation)
            }
        }

        for stop in closest {
            var coordinates = CLLocationCoordinate2D()
            coordinates.latitude = stop.location.latitude
            coordinates.longitude = stop.location.longitude

            DispatchQueue.main.async {
                self.mapView.addAnnotation(PlaceAnnotationModel(coordinates, "\(stop.displayName) (\(stop.distance))"))
            }
        }
        
        DispatchQueue.main.async {
            self.mapMessages.text = "Update complete"
        }
    }
    
    private func getClosestStops(_ latitude: Double, _ longtitude: Double) -> [StopModel] {
        DispatchQueue.main.async {
            self.mapMessages.text = "Getting stops..."
        }
        var closestStops:[StopModel] = []
        var computed:Double = 0.00
        
        //compute distance and find closest stops depending upon distance
        
        for stop in stops {
            //do not add if stop exists (due to multiple routes)
            
            if !closestStops.contains(where: {$0.displayName == stop.displayName}) {
                computed = self.computeDistance(latitude.roundTo(places: 2), longtitude.roundTo(places: 2), stop.location.latitude.roundTo(places: 2), stop.location.longitude.roundTo(places: 2))
            
                if computed <= self.maxDistance {
                    var closest = StopModel()
                    closest?.id = stop.id
                    closest?.displayName = stop.displayName
                    closest?.distance = computed
                    closest?.location.latitude = stop.location.latitude
                    closest?.location.longitude = stop.location.longitude
                    closestStops.append(closest!)
                }
            }
        }
        
        //in place sort asc
        closestStops.sort(by: { $0.distance > $1.distance })
        
        //return top 20
        return Array(closestStops.prefix(20))
    }
    
    public func computeDistance(_ uLat: Double, _ uLng: Double, _ sLat: Double, _ sLng: Double) -> Double {
        
        let radius: Double = 3959.0 // Miles
        
        let deltaP = (sLat.degreesToRadians - uLat.degreesToRadians)
        let deltaL = (sLng.degreesToRadians - uLng.degreesToRadians)
        let a = sin(deltaP/2) * sin(deltaP/2) + cos(uLat.degreesToRadians) * cos(sLat.degreesToRadians) * sin(deltaL/2) * sin(deltaL/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        let d = radius * c
        
        return d.roundTo(places: 2) // distance in miles rounded to 2 decimal places
    }
}

