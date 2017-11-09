//
//  CoreGateway.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/8/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

class CoreGateway {
    
    typealias Completion<T: JSONValueConvertible> = (Response<ResponseData<T>>) -> ()
    typealias ComposerClosure = (URLRequestComposer) -> ()
    
    let configuration: WebServiceConfiguration
    private let restClient: RestClient
    
    init(configuration: WebServiceConfiguration, restClient: RestClient) {
        self.configuration = configuration
        self.restClient = restClient
    }
    
    func perform<T>(_ composerClosure: ComposerClosure, context: Any? = nil, completion: @escaping Completion<T>) -> CancellationToken? {
        let composer = URLRequestComposer(baseURL: configuration.baseURL)
        composerClosure(composer)
        guard let urlRequest = composer.urlRequest else {
            completion(.failure(error: .failedToBuildURLRequest))
            return nil
        }
        return perform(urlRequest, context: context, completion: completion)
    }
    
    private func perform<T>(_ request: URLRequest, context: Any? = nil, completion: @escaping Completion<T>) -> CancellationToken {
        return restClient.perform(request) { [weak self] data, error in
            guard let strongSelf = self else { return }
            do {
                try strongSelf.handle(error)
                let aData = try strongSelf.check(data)
                let json = try strongSelf.serialize(aData)
                
                let response: ResponseData<T> = try strongSelf.map(json, context: context)
                DispatchQueue.main.async {
                    completion(.success(data: response))
                }
            } catch let error as CoreGatewayError {
                DispatchQueue.main.async {
                    completion(.failure(error: error))
                }
            } catch {
                print("Unhandled \(String(describing: type(of: strongSelf))) error")
            }
        }
    }
    
    private func handle(_ error: RestClientError?) throws {
        if let error = error {
            throw CoreGatewayError(restClientError: error)
        }
    }
    
    private func check(_ data: Data?) throws -> Data {
        guard let data = data, data.count > 0 else {
            throw CoreGatewayError.noData
        }
        return data
    }
    
    private func serialize(_ data: Data) throws -> Any {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            throw CoreGatewayError.jsonSerializationFailed(error)
        }
    }
    
    private func map<T: JSONValueConvertible>(_ json: Any, context: Any?) throws -> ResponseData<T> {
        guard let aJson = json as? [String: Any],
            let response = ResponseData<T>.makeInstance(aJson, context: context) else {
                throw CoreGatewayError.mappingFailed
        }
        return response
    }
    
    func handleResponseForAnItem<T>(_ response: Response<ResponseData<T>>, completion: @escaping (CoreGateway.Response<T>) -> ()) {
        switch response {
        case .success(let responseEntity):
            if let responseData = responseEntity.content, case .anItem(let data) = responseData  {
                completion(.success(data: data))
            } else {
                completion(.failure(error: .mappingFailed))
            }
        case .failure(let error): completion(.failure(error: error))
        }
    }

    func handleResponseForItems<T>(_ response: Response<ResponseData<T>>, completion: @escaping (CoreGateway.Response<[T]>) -> ()) {
        switch response {
        case .success(let responseEntity):
            if let responseData = responseEntity.content, case .items(let data) = responseData  {
                completion(.success(data: data))
            } else {
                completion(.failure(error: .mappingFailed))
            }
        case .failure(let error): completion(.failure(error: error))
        }
    }
}

extension CoreGateway {
    enum Response<T> {
        case success(data: T)
        case failure(error: CoreGatewayError)
    }
}

enum CoreGatewayError: Error {
    case failedToBuildURLRequest
    case noData
    case jsonSerializationFailed(Error)
    case mappingFailed
    case notConnectedToInternet
    case cancelled
    case networkError(Error)
    case httpError(data: Data?, statusCode: Int)
    case webServerError(errorData: ResponseError, statusCode: Int)
    case unauthorized
}

extension CoreGatewayError {
    
    init(restClientError: RestClientError) {
        switch restClientError {
        case .notConnectedToInternet: self = .notConnectedToInternet
        case .cancelled: self = .cancelled
        case .networkError(let error): self = .networkError(error)
        case .httpError(let data, let statusCode):
            if statusCode == 401 {
                self = .unauthorized
            } else if let data = data,
                let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
                let errorData = ResponseError.makeInstance(json){
                self = .webServerError(errorData: errorData, statusCode: statusCode)
            } else {
                self = .httpError(data: data, statusCode: statusCode)
            }
        }
    }
    
}

protocol CancellationToken {
    
    func cancel()
}

extension RestClient.CancellationToken: CancellationToken {}
