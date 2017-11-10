//
//  Temperature.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/9/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

struct Temperature {
    
    fileprivate(set) var celsius: String
    fileprivate(set) var fahrenheit: String
    
    var prettyCelsius: String { return celsius.isEmpty ? celsius : "\(celsius)°" }
    var prettyFahrenheit: String { return fahrenheit.isEmpty ? fahrenheit : "\(fahrenheit)°" }
}

extension Temperature: Mappable {
    
    init() {
        self.init(celsius: "", fahrenheit: "")
    }
    
    static func makeInstance(_ map: Map) -> Temperature? {
        return Temperature()
    }
    
    mutating func map(with map: Map) {
        let keys = map.context as? [String : String]
        map.bind(&celsius, key: keys?[MappingKeysDefault.celsius] ?? MappingKeysDefault.celsius )
        map.bind(&fahrenheit, key: keys?[MappingKeysDefault.fahrenheit] ?? MappingKeysDefault.fahrenheit)
    }
}

extension Temperature {
    
    enum MappingKeysDefault {
        static let celsius = "celsius"
        static let fahrenheit = "fahrenheit"
    }
    
    enum MappingKeysCustom {
        static let feelsLikeKeys = [MappingKeysDefault.celsius : "feelslike_c", MappingKeysDefault.fahrenheit : "feelslike_f"]
        static let temperatureKeys = [MappingKeysDefault.celsius : "temp_c", MappingKeysDefault.fahrenheit : "temp_f"]
    }
}
