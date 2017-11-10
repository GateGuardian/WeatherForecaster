//
//  Dependencies.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/10/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation
import CoreLocation

protocol Dependencies {
    var coreGateway: CoreGateway { get }
    var locationManager: CLLocationManager { get }
}

final class DefaultDependencies: Dependencies {

    let coreGateway: CoreGateway
    let locationManager: CLLocationManager
    
    init(coreGateway: CoreGateway, locationManager: CLLocationManager) {
        self.coreGateway = coreGateway
        self.locationManager = locationManager
    }
}

class DependenciesContainer {
    
    let dependencies: Dependencies
    
    init(_ dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
}
