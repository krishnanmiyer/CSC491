//
//  LocationService.swift
//  Mahadevan_K_LAMetroMap
//
//  Created by Krishnan Mahadevan on 5/21/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import CoreLocation

/**
protocol to Implement Singleton instance of Location service
 */

protocol LocationServiceDelegate {
    func traceLocation(currentLocation: CLLocation)
    func traceLocationError(error: Error)
}

/**
 Implementation of LocationService Protocol
 */
class LocationService: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate?
   
    /**
     Returns instance of LocationService.
     */
    static let sharedInstance = LocationService()
    
    /**
     private constructor to the Singleton.
     */
    private override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        locationManager.delegate = self
    }
    
    /**
     Starts updating location
     */
    func startUpdatingLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager?.startUpdatingLocation()
        }
    }
    
    /**
     Stops updating location
     */
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    /**
     Invoked by Locaton Manager to update location
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.currentLocation = location
        
        updateLocation(currentLocation: location)
    }
    
    /**
     Invoked by Locaton Manager when location update fails
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationFailed(error: error)
    }
    
    /**
     Updates location and invokes traceLocation delegate.
     
     - parameter currentLocation:  instance of CLLocation.
     */
    private func updateLocation(currentLocation: CLLocation){
        guard let delegate = self.delegate else {
            return
        }
        delegate.traceLocation(currentLocation: currentLocation)
    }

    /**
     Invokes traceLocationError delegate.
     
     - parameter currentLocation:  instance of Error.
     */
    private func updateLocationFailed(error: Error) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.traceLocationError(error: error)
    }
}
