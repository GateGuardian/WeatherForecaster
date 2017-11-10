//
//  WeatherViewModel.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/10/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

class WeatherViewModel: WeatherViewModelInterface {
    
    var didUpdateWeatherForecast: (() -> Void)?
    var didUpdateCurrentConditions: (() -> Void)?
    
    var currentConditions: CurrentConditionViewModel? {
        didSet {
            didUpdateCurrentConditions?()
        }
    }
    var weatherForecastItems: [WeatherForecastItemViewModel] = [] {
        didSet {
            didUpdateWeatherForecast?()
        }
    }
    
    var geoLocationInteractor: GeoLocationInteractorInterface
    var currentConditionsInteractor: CurrentConditionsInteractorInterface
    var forecastInteractor: ForecastInteractorInterface
    
    
    //MARK: Lifecycle
    
    init(geoLocationInteractor: GeoLocationInteractorInterface, currentConditionsInteractor: CurrentConditionsInteractorInterface, forecastInteractor: ForecastInteractorInterface) {
        self.geoLocationInteractor = geoLocationInteractor
        self.currentConditionsInteractor = currentConditionsInteractor
        self.forecastInteractor = forecastInteractor
    }
    
    
    func fetchData() {
        //Fetching GeoLocation
        geoLocationInteractor.fetchCurrentGeoLocation()
    }
    
    private func conditionsViewModel(fromConditions conditions: CurrentConditions) -> CurrentConditionViewModel  {
        return CurrentConditionViewModel(temperature: conditions.temperature?.prettyCelsius, feelsLikeTemperature: conditions.feelsLikeTemperature?.prettyCelsius,  humidity: conditions.humidity, windInfo: conditions.wind?.infoString(), date: conditions.date?.date.fullDate(), conditionDescription: conditions.conditionDescription, imageURL: conditions.imageURL)
    }
    
    private func weatherForecastItems(fromForecast forecast: [ForecastDay]) -> [WeatherForecastItemViewModel] {
        let items = forecast.map { forecastDay -> WeatherForecastItemViewModel in
            return WeatherForecastItemViewModel(minT: forecastDay.lowTemp.prettyCelsius, maxT: forecastDay.highTemp.prettyCelsius, day: forecastDay.date.date.weekDay(), imageURL: forecastDay.imageURL, isToday: forecastDay.date.date.isToday)
        }
        return items
    }
}

extension WeatherViewModel: GeoLocationInteractorDelegate {
    func didFetchCurrentGeoLocation(_ location: GeoLocation) {
        //TODO: update Title with City Name
        //1. Fetch current conditions
        currentConditionsInteractor.fetchConditions(for: location)
        //2. Fetch forecast
        forecastInteractor.fetchForecast(for: location)
    }
    
    func didFailToFetchGeoLocation(withError: CoreGatewayError) {
        //TODO: show error
    }
}

extension WeatherViewModel: CurrentConditionsInteractorDelegate {
    func didFetchConditions(_ conditions: CurrentConditions) {
        currentConditions = conditionsViewModel(fromConditions: conditions)
    }
    
    func didFailToFetchConditions(withError error: CoreGatewayError) {
        //TODO: show error
    }
}

extension WeatherViewModel: ForecastInteractorDelegate {
    func didFetchForecast(_ forecast: [ForecastDay]) {
        weatherForecastItems = weatherForecastItems(fromForecast: forecast)
    }
    
    func didFailToFetchForecast(withError error: CoreGatewayError) {
        //TODO: show error
    }
}
