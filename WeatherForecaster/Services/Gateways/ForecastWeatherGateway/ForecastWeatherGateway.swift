//
//  ForecastWeatherGateway.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/8/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

protocol ForecastWeatherGateway {
    typealias ForecastWeatherCompletion = (CoreGateway.Response<[ForecastDay]>) -> ()
    
    func fetchForecast(location: GeoLocation, completion: @escaping ForecastWeatherCompletion) -> CancellationToken?
}

enum ForecastWeatherGatewayPath {
    static let forecast = "/forecast/q/"
}

extension CoreGateway: ForecastWeatherGateway {
    func fetchForecast(location: GeoLocation, completion: @escaping ForecastWeatherCompletion) -> CancellationToken? {
        let mappingContext = ResponseDataMappingContext(rootKey: "forecast", embeddedContentKey: "simpleforecast.forecastday")
        return perform({ (composer) in
            composer.path = ForecastWeatherGatewayPath.forecast + location.urlPath() + ".json"
        }, context: mappingContext, completion: { (response: Response<ResponseData<ForecastDay>>) in
            self.handleResponseForItems(response, completion: completion)
        })
    }
}
