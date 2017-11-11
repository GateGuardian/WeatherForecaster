//
//  WeatherViewModel.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/10/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

class WeatherViewModel: WeatherViewModelInterface {
    
    //MARK: WeatherViewModelInterface
    
    var didUpdateWeatherForecast: (() -> Void)?
    var didUpdateCurrentConditions: (() -> Void)?
    var didUpdateCityName: ((_ cityName: String ) -> Void)?
    var didFinishLoading: (() -> Void)?
    var onShowAlert: ((_ errorDescription: ErrorDescription) -> Void)?
    
    var currentConditions: CurrentConditionViewModel? {
        didSet {
            didUpdateCurrentConditions?()
            didFinishLoading?()
        }
    }
    var weatherForecastItems: [WeatherForecastItemViewModel] = [] {
        didSet {
            didUpdateWeatherForecast?()
            didFinishLoading?()
        }
    }
    
    var geoLocationInteractor: GeoLocationInteractorInterface
    var currentConditionsInteractor: CurrentConditionsInteractorInterface
    var forecastInteractor: ForecastInteractorInterface
    
    func fetchData() {
        geoLocationInteractor.fetchCurrentGeoLocation()
    }
    
    func refreshData() {
        geoLocationInteractor.refreshCurrentGeoLocation()
    }
    
    //MARK: Lifecycle
    
    init(geoLocationInteractor: GeoLocationInteractorInterface, currentConditionsInteractor: CurrentConditionsInteractorInterface, forecastInteractor: ForecastInteractorInterface) {
        self.geoLocationInteractor = geoLocationInteractor
        self.currentConditionsInteractor = currentConditionsInteractor
        self.forecastInteractor = forecastInteractor
    }

    //MARK: Private
    
    private func conditionsViewModel(fromConditions conditions: CurrentConditions) -> CurrentConditionViewModel  {
        return CurrentConditionViewModel(temperature: conditions.temperature?.prettyCelsius, feelsLikeTemperature: conditions.feelsLikeTemperature?.prettyCelsius,  humidity: conditions.humidity, pressure: conditions.prettyPressure, windInfo: conditions.wind?.infoString(), date: conditions.date?.date.fullDate(), conditionDescription: conditions.conditionDescription, imageURL: conditions.imageURL)
    }
    
    private func weatherForecastItems(fromForecast forecast: [ForecastDay]) -> [WeatherForecastItemViewModel] {
        let items = forecast.map { forecastDay -> WeatherForecastItemViewModel in
            let isToday = forecastDay.date.date.isToday
            let weekDay = forecastDay.date.date.weekDay()
            let dateString = isToday ? weekDay + " today" : weekDay
            let temperatureString = forecastDay.highTemp.prettyCelsius + "   " + forecastDay.lowTemp.prettyCelsius
            return WeatherForecastItemViewModel(temperatureString: temperatureString, day: dateString, imageURL: forecastDay.imageURL)
        }
        return items
    }
    
    private func show(error: Error) {
        didFinishLoading?()
        let errorDescription = ErrorFormatter().string(from: error)
        onShowAlert?(errorDescription)
    }
}

extension WeatherViewModel: GeoLocationInteractorDelegate {
    func didFetchCurrentGeoLocation(_ location: GeoLocation) {
        //1. update Title with City Name
        didUpdateCityName?(location.city)
        //2. Fetch current conditions
        currentConditionsInteractor.fetchConditions(for: location)
        //3. Fetch forecast
        forecastInteractor.fetchForecast(for: location)
    }
    
    func didFailToFetchGeoLocation(withError: Error) {
        show(error: withError)
    }
}

extension WeatherViewModel: CurrentConditionsInteractorDelegate {
    func didFetchConditions(_ conditions: CurrentConditions) {
        currentConditions = conditionsViewModel(fromConditions: conditions)
    }
    
    func didFailToFetchConditions(withError error: Error) {
        show(error: error)
    }
}

extension WeatherViewModel: ForecastInteractorDelegate {
    func didFetchForecast(_ forecast: [ForecastDay]) {
        weatherForecastItems = weatherForecastItems(fromForecast: forecast)
    }
    
    func didFailToFetchForecast(withError error: Error) {
        show(error: error)
    }
}
