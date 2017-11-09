//
//  WebServiceConfiguration.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/7/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

struct WebServiceConfiguration {
    
    let baseURL: URL
    let apiKey: String
    
    static var `default`: WebServiceConfiguration {
        let url = URL(string: "http://api.wunderground.com/api/b8e93686720a3c8e")!
        let apiKey = "b8e93686720a3c8e"
        return WebServiceConfiguration(baseURL: url, apiKey: apiKey)
    }
    
}
