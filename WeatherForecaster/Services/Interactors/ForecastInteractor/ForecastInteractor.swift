//
//  ForecastInteractor.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/10/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

protocol ForecastInteractorInterface: class {
    func fetchForecast(`for` location: GeoLocation)
    func cancelFetching()
}

protocol ForecastInteractorDelegate: class {
    func didFetchForecast(_ forecast: [ForecastDay])
    func didFailToFetchForecast(withError error: CoreGatewayError)
}

class ForecastInteractor: ForecastInteractorInterface {
    
    weak var delegate: ForecastInteractorDelegate?
    private let forecastGateway: ForecastWeatherGateway
    private var cancelationToken: CancellationToken?
    
    //MARK: Lifecycle
    
    init(forecastGateway: ForecastWeatherGateway) {
        self.forecastGateway = forecastGateway
    }
    
    //MARK: ForecastInteractorInterface
    
    func fetchForecast(`for` location: GeoLocation) {
        cancelationToken = forecastGateway.fetchForecast(location: location, completion: { [weak self] (response) in
            guard let strongSelf = self else { return }
            switch response {
                case .failure(let error) : strongSelf.delegate?.didFailToFetchForecast(withError: error)
                case.success(let data): strongSelf.delegate?.didFetchForecast(data)
            }
        })
    }
    
    func cancelFetching() {
        cancelationToken?.cancel()
    }
}
