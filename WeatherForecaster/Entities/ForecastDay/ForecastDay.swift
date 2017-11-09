//
//  ForecastDay.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/9/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

//Short Forecast Info for Day
struct DayForecast {
    fileprivate(set) var date: DateEntity
    fileprivate(set) var highTemp: Temperature
    fileprivate(set) var lowTemp: Temperature
    fileprivate(set) var imageURL: URL
}

extension DayForecast: Mappable {
    
    init() {
        self.init(date: DateEntity(), highTemp: Temperature(), lowTemp: Temperature(), imageURL: URL(string: "https://www.apple.com")!)
    }
    
    static func makeInstance(_ map: Map) -> DayForecast? {
        return DayForecast()
    }
    
    mutating func map(with map: Map) {
        map.bind(&date, key: "date")
        map.bind(&highTemp, key: "high")
        map.bind(&lowTemp, key: "low")
        map.bind(&imageURL, key: "icon_url")
    }
}
