//
//  Wind.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/9/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

struct Wind {
    fileprivate(set) var direction: String
    fileprivate(set) var speedMph: String
    fileprivate(set) var speedKmh: String
}

extension Wind: Mappable {
    
    init() {
        self.init(direction: "", speedMph: "", speedKmh: "")
    }
    
    static func makeInstance(_ map: Map) -> Wind? {
        return Wind()
    }
    
    mutating func map(with map: Map) {
        map.bind(&direction, key: "wind_dir")
        map.bind(&speedMph, key: "wind_mph")
        map.bind(&speedKmh, key: "wind_kph")
    }
}
