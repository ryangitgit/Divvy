//
//  DivvyStation.swift
//  Divvy Mapper
//
//  Created by Ryan Weatherby on 5/4/21.
//

import Foundation
import CoreLocation.CLLocation
struct DivvyStation: Codable {
    let station_name: String
    let status: String
    let latitude: String
    let longitude: String
  let docks_in_service: String?
    var coordinate: CLLocationCoordinate2D?{
        guard let latitude = Double(latitude), let longitude = Double(longitude)
        else{
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var location: CLLocation{
        return CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
    }
    func distance(to location: CLLocation) -> CLLocationDistance{
        return location.distance(from: self.location)
    }
}
