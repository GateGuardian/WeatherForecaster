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
