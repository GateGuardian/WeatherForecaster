//
//  WeatherBuilder.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/10/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import UIKit

class WeatherBuilder: DependenciesContainer {
    
    func build() -> WeatherViewController {
        let controller: WeatherViewController = UIStoryboard(.main).instantiateViewController()
        controller.viewModel = makeViewModel()
        return controller
    }
    
    private func makeViewModel() -> WeatherViewModel {
        let currentConditionsInteractor = CurrentConditionsInteractor(currentConditionsGateway: dependencies.coreGateway)
        let forecastInteractor = ForecastInteractor(forecastGateway: dependencies.coreGateway)
        let geoLocationInteractor = GeoLocationInteractor(geoLocationGateway: dependencies.coreGateway, coreLocationManager: dependencies.locationManager)
        
        let viewModel = WeatherViewModel(geoLocationInteractor: geoLocationInteractor, currentConditionsInteractor: currentConditionsInteractor, forecastInteractor: forecastInteractor)
        
        currentConditionsInteractor.delegate = viewModel
        forecastInteractor.delegate = viewModel
        geoLocationInteractor.delegate = viewModel
        return viewModel
    }
}
