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
    var date: DateEntity
    
    var temperature: Temperature
    var feelsLikeTemperature: Temperature
    var wind: Wind
    
    var humidity: String //relative_humidity
    var conditionDescription: String //weather
    var imageURL: URL //icon_url
    
}
