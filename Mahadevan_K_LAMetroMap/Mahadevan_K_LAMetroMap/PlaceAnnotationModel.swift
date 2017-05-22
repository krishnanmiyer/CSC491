//
//  PlaceModel.swift
//  Mahadevan_K_LAMetroMap
//
//  Created by Krishnan Mahadevan on 5/21/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotationModel : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(_ coordinate: CLLocationCoordinate2D,
         _ title: String? = nil,
         _ subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
