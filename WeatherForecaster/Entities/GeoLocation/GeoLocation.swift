//
//  GeoLocation.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/7/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

struct GeoLocation {
    fileprivate(set) var country: String
    fileprivate(set) var state: String
    fileprivate(set) var city: String
    
    func urlPath() -> String {
        var path = country == GeoLocation.USACountryName ? "\(state)" : "\(country)" 
        path += "/\(city)"
        return path
    }
}

extension GeoLocation: Mappable {
    
    init() {
        self.init(country: "", state: "", city: "")
    }
    
    static func makeInstance(_ map: Map) -> GeoLocation? {
        return GeoLocation()
    }
    
    mutating func map(with map: Map) {
        map.bind(&country, key: "country_name")
        map.bind(&state, key: "state")
        map.bind(&city, key: "city")
    }
}

extension GeoLocation {
    static fileprivate let USACountryName = "USA"
}

