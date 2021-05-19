//
//  CLLocationDistance.swift
//  Divvy Mapper
//
//  Created by Ryan Weatherby on 5/15/21.
//

import Foundation
import UIKit
import CoreLocation

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }

    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}
