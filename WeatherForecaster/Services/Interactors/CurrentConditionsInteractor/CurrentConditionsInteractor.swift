//
//  CurrentConditionsInteractor.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/10/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

protocol CurrentConditionsInteractorInterface: class {
    func fetchConditions(`for`: GeoLocation)
    func cancelFetching()
}

protocol CurrentConditionsInteractorDelegate: class {
    func didFetchConditions(_ conditions: CurrentConditions)
    func didFailToFetchConditions(withError error: CoreGatewayError)
}

class CurrentConditionsInteractor: CurrentConditionsInteractorInterface {
    
    weak var delegate: CurrentConditionsInteractorDelegate?
    private let currentConditionsGateway: CurrentConditionsGateway
    private var cancelationToken: CancellationToken?
    
    //MARK: Lifecycle
    
    init(currentConditionsGateway: CurrentConditionsGateway) {
        self.currentConditionsGateway = currentConditionsGateway
    }
    
    //MARK: CurrentConditionsInteractorInterface
    
    func fetchConditions(`for` location: GeoLocation) {
        cancelationToken = currentConditionsGateway.fetchCurrentConditions(location: location, completion: { [weak self] (response) in
            guard let strongSelf = self else { return }
            switch response {
                case .failure(let error) : strongSelf.delegate?.didFailToFetchConditions(withError: error)
                case.success(let data): strongSelf.delegate?.didFetchConditions(data)
            }
        })
    }
    
    func cancelFetching() {
        cancelationToken?.cancel()
    }
}
