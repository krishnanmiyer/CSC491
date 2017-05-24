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

    private var applied = CLLocationCoordinate2D()

    var dataAvailable = false
    var routes:[Int] = []
    
    let maxDistance = 2.00
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (MetroService.stops.count < 1) {
            LoadStops()
        }
        else {
            dataAvailable = true
            self.updatePins(self.applied.latitude, self.applied.longitude)
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

    private func LoadStops() {
        mapMessages.text = "Loading data..."
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        queue.async {
            MetroService.getStopsInRoutes(routes: self.routes) { result in
                MetroService.stops.append(contentsOf: result)

                self.dataAvailable = true
                self.updatePins(self.applied.latitude, self.applied.longitude)
            }
        }
    }
    
    func traceLocation(currentLocation: CLLocation) {
        if (applied.latitude == 0 && applied.longitude == 0) {
            applied = currentLocation.coordinate
        }
        else {
            let distance = computeDistance(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, applied.latitude, applied.longitude)
            
            //minimum distance when map has to be updated
            if distance <= 0.5 {
                return
            }
            
            if (dataAvailable) {
                updatePins(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
                applied = currentLocation.coordinate
            }
        }
        mapView.setRegion(MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
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
            
            MetroService.getRealTime(stop.id) { realTimeData in
                let sorted = realTimeData.sorted(by: { $0.minutes < $1.minutes }).first
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(PlaceAnnotationModel(coordinates, "\(stop.displayName) (\(stop.distance))", sorted?.toString()))
                }
            }
        }
                
        DispatchQueue.main.async {
            if let first = closest.sorted(by: { $0.distance > $1.distance }).last {
                self.mapMessages.text = "Nearest Metro: \(first.displayName) (\(first.distance)M)"
            }
            else {
                self.mapMessages.text = ""
            }
        }
    }
    
    private func getClosestStops(_ latitude: Double, _ longtitude: Double) -> [StopModel] {
        DispatchQueue.main.async {
            self.mapMessages.text = "Getting stops..."
        }
        var closestStops:[StopModel] = []
        var computed:Double = 0.00
        
        //compute distance and find closest stops depending upon distance
        
        for stop in MetroService.stops {
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

