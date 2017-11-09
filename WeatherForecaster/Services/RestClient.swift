//
//  RestClient.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/7/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

class RestClient {
    
    typealias Completion = (_ data: Data?, _ error: RestClientError?) -> Void
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    func perform(_ request: URLRequest, _ completion: @escaping Completion) -> CancellationToken {
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                self.handleNetworkError(error, completion)
            } else if let httpResponse = response as? HTTPURLResponse {
                if Constants.httpStatusCodeErrorRange ~= httpResponse.statusCode {
                    completion(data, .httpError(data: data, statusCode: httpResponse.statusCode))
                } else {
                    completion(data, nil)
                }
            } else {
                completion(data, nil)
            }
        }
        task.resume()
        return CancellationToken { task.cancel() }
    }
    
    private func handleNetworkError(_ error: Error, _ completion: Completion) {
        switch (error as NSError).code {
        case NSURLErrorNotConnectedToInternet: completion(nil, .notConnectedToInternet)
        case NSURLErrorCancelled: completion(nil, .cancelled)
        default: completion(nil, .networkError(error))
        }
    }
    
}

extension RestClient {
    
    final class CancellationToken {
        
        private let closure: () -> Void
        
        fileprivate init(closure: @escaping () -> Void) {
            self.closure = closure
        }
        
        func cancel() {
            closure()
        }
        
    }
    
    enum Constants {
        static let httpStatusCodeErrorRange = 400..<600
    }
    
}

enum RestClientError: Error {
    
    case cancelled
    case notConnectedToInternet
    case networkError(Error)
    case httpError(data: Data?, statusCode: Int)
    
}
