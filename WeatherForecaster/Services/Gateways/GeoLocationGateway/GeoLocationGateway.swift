//
//  GeoLocationGateway.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/8/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation
import CoreLocation

protocol GeoLocationGateway {
    typealias GeoLocationCompletion = (CoreGateway.Response<GeoLocation>) -> ()
    
    func geoLocation(withLocation location: CLLocation, completion: @escaping GeoLocationCompletion) -> CancellationToken?
}

enum GeoLocationGatewayPath {
    static let geoLookUp = "/geolookup/q/"
}

extension CoreGateway: GeoLocationGateway {
    
    func geoLocation(withLocation location: CLLocation, completion: @escaping (CoreGateway.Response<GeoLocation>) -> ()) -> CancellationToken? {
        let mappingContext = ResponseDataMappingContext(rootKey: "location", embeddedContentKey: nil)
        return perform({ (composer) in
            composer.path = GeoLocationGatewayPath.geoLookUp + "\(location.coordinate.latitude)" + "," + "\(location.coordinate.longitude)" + ".json"
        }, context: mappingContext, completion: { (response: Response<ResponseData<GeoLocation>>) in
            self.handleResponseForAnItem(response, completion: completion)
        })
    }
}
