//
//  CurrentConditionsGateway.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/9/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

protocol CurrentConditionsGateway {
    typealias CurrentConditionsCompletion = (CoreGateway.Response<CurrentConditions>) -> ()
    
    func fetchCurrentConditions(location: GeoLocation, completion: @escaping CurrentConditionsCompletion) -> CancellationToken?
}

enum CurrentConditionsGatewayPath {
    static let currentConditions = "/conditions/q/"
}

extension CoreGateway: CurrentConditionsGateway {
    func fetchCurrentConditions(location: GeoLocation, completion: @escaping CurrentConditionsGateway.CurrentConditionsCompletion) -> CancellationToken? {
        let mappingContext = ResponseDataMappingContext(rootKey: "current_observation", embeddedContentKey: nil)
        return perform({ (composer) in
            composer.path = CurrentConditionsGatewayPath.currentConditions + location.urlPath() + ".json"
        }, context: mappingContext, completion: { (response: Response<ResponseData<CurrentConditions>>) in
            self.handleResponseForAnItem(response, completion: completion)
        })
    }
}
