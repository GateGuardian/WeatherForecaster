//
//  ErrorFormatter.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/11/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

class ErrorFormatter {
    
    private let title = "Error"
    
    func string(from error: Error) -> ErrorDescription {
        if let error = error as? CoreGatewayError {
            return string(from: error)
        } else if let error = error as? CoreLocationError {
            return string(from: error)
        } else {
            return ErrorDescription(title: nil, message: error.localizedDescription)
        }
    }
    
    private func string(from error: CoreLocationError) -> ErrorDescription {
        switch error {
        case .errorDenied:
            return ErrorDescription(title: title, message: CoreLocationErrorMessages.errorDenied.rawValue)
        case .errorNetwork:
            return ErrorDescription(title: title, message: CoreLocationErrorMessages.errorNetwork.rawValue)
        case .errorLocationUnknown:
            return ErrorDescription(title: title, message: CoreLocationErrorMessages.errorLocationUnknown.rawValue)
        default:
            return ErrorDescription(title: title, message: CoreLocationErrorMessages.errorUnknown.rawValue)
        }
    }
    
    private func string(from error: CoreGatewayError) -> ErrorDescription {
        switch error {
        case .failedToBuildURLRequest:
            return ErrorDescription(title: title, message: CoreGatewayErrorMessages.failedToBuildURLRequest.rawValue)
        case .notConnectedToInternet:
            return ErrorDescription(title: title, message: CoreGatewayErrorMessages.noInternetConnection.rawValue)
        case .noData:
            return ErrorDescription(title: title, message: CoreGatewayErrorMessages.receivedEmptyResponse.rawValue)
        case .jsonSerializationFailed(let error):
            return ErrorDescription(title: title, message: CoreGatewayErrorMessages.jsonSerializationFailed.rawValue + " " + error.localizedDescription)
        case .mappingFailed:
            return ErrorDescription(title: title, message: CoreGatewayErrorMessages.failedToMapJSON.rawValue)
        case .cancelled:
            return ErrorDescription(title: title, message: CoreGatewayErrorMessages.operationWasCancelled.rawValue)
        case .networkError(let error):
            let message = CoreGatewayErrorMessages.networkError.rawValue + " " + error.localizedDescription
            return ErrorDescription(title: title, message: message)
        case .httpError(let data, _):
            return descriptionForHTTPError(with: data)
        case .webServerError(let responseError, _):
            return descriptionForWebServerError(responseError)
        case .unauthorized:
            return ErrorDescription(title: title, message: CoreGatewayErrorMessages.youMustBeLoggedIn.rawValue)
        }
    }
    
    private func descriptionForHTTPError(with data: Data?) -> ErrorDescription {
        var message: String = CoreGatewayErrorMessages.someNetworkError.rawValue
        if let data = data, let string = String(data: data, encoding: .utf8) {
            message += " \(string)"
        }
        return ErrorDescription(title: title, message: message)
    }
    
    private func descriptionForWebServerError(_ error: ResponseError) -> ErrorDescription {
        if let userInfo = error.userInfo {
            var userInfoDescription = userInfo.reduce("") { $0 + "\n\($1.key): \($1.value)" }
            userInfoDescription = userInfoDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return ErrorDescription(title: error.message, message: userInfoDescription)
        } else {
            return ErrorDescription(title: nil, message: error.message)
        }
    }
}
