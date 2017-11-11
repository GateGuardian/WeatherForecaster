//
//  Constants.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/11/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

enum CoreGatewayErrorMessages: String {
    case noInternetConnection = "Your internet connection appears to be down. Please check and try again"
    case receivedEmptyResponse = "Received empty response"
    case networkError = "Network error"
    case failedToMapJSON = "Failed to map json into object"
    case operationWasCancelled = "Operation was cancelled"
    case youMustBeLoggedIn = "You must be logged in to perform this operation"
    case failedToBuildURLRequest = "Failed to build URLRequest"
    case jsonSerializationFailed = "JSON serialization failed with error: %@"
    case someNetworkError = "Some network error: %@"
    
}

enum CoreLocationErrorMessages: String {
    case errorLocationUnknown = "Location is currently unknown, but CL will keep trying"
    case errorDenied = "Access to location or ranging has been denied by the user"
    case errorNetwork = "Some network-related error"
    case errorUnknown = "Some location error"
}
