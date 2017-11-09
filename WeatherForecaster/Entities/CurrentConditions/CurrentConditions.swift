//
//  CurrentConditions.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/9/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

//Current Weather Conditions
struct CurrentConditions {
    
    var date: DateEntity?
    var temperature: Temperature?
    var feelsLikeTemperature: Temperature?
    var wind: Wind?
    
    var humidity: String
    var conditionDescription: String
    var imageURL: URL

}

extension CurrentConditions: Mappable {
    
    init() {
        self.init(date: DateEntity(), temperature: Temperature(), feelsLikeTemperature: Temperature(), wind: Wind(), humidity: "", conditionDescription: "", imageURL: URL(string: "https://www.apple.com")!)
    }
    
    static func makeInstance(_ map: Map) -> CurrentConditions? {
        return CurrentConditions()
    }
    
    mutating func map(with map: Map) {
        map.bind(&humidity, key: "relative_humidity")
        map.bind(&conditionDescription, key: "weather")
        map.bind(&imageURL, key: "icon_url")
        
        //semi-mannual mapping =((((
        
        self.date = DateEntity.makeInstance(map.json, context: DateEntity.MappingKeysCustom.currentConditionsKeys)
        self.temperature = Temperature.makeInstance(map.json, context: Temperature.MappingKeysCustom.temperatureKeys)
        self.feelsLikeTemperature = Temperature.makeInstance(map.json, context: Temperature.MappingKeysCustom.feelsLikeKeys)
        self.wind = Wind.makeInstance(map.json)
    }
}
