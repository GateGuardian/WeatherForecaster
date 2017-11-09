//
//  URLRequestComposer.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/7/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

final class URLRequestComposer {
    var baseURL: URL
    var path: String = ""
    var queryItems: [String: String]?
    var httpMethod: HTTPMethod = .GET
    var httpHeaders: [String: String]?
    var body: Body?
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = httpHeaders
        if let body = body {
            request = set(body, in: request)
        }
        return request
    }
    
    private var url: URL? {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { return nil }
        components.path += path
        components.queryItems = queryItems?.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url
    }
    
    private func set(_ body: Body, `in` request: URLRequest) -> URLRequest {
        guard let data = body.data else { return request }
        var aRequest = request
        aRequest.httpBody = data
        aRequest.addValue(String(describing: data.count), forHTTPHeaderField: HeaderField.contentLength)
        switch body {
        case .json:
            aRequest.addValue(ContentType.applicationJSON, forHTTPHeaderField: HeaderField.contentType)
        default: break
        }
        return aRequest
    }
}

extension URLRequestComposer {
    
    enum HeaderField {
        static let contentType = "Content-Type"
        static let contentLength = "Content-Length"
    }
    
    enum ContentType {
        static let applicationJSON = "application/json"
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
        case HEAD
        case PATCH
        case OPTIONS
    }
    
    enum Body {
        
        case raw(Data)
        case json(Any)
        case jsonConvertible(JSONValueConvertible, context: Any?)
        
        
        var data: Data? {
            switch self {
            case .raw(let data): return data
            case .json(let json): return serialize(json)
            case .jsonConvertible(let jsonConvertible, let context): return map(jsonConvertible, context: context)
            }
        }
        
        private func serialize(_ json: Any) -> Data? {
            guard JSONSerialization.isValidJSONObject(json) else { return nil }
            return try? JSONSerialization.data(withJSONObject: json)
        }
        
        private func map(_ jsonConvertible: JSONValueConvertible, context: Any?) -> Data? {
            guard let json = jsonConvertible.jsonValue(context) else { return nil }
            return serialize(json)
        }
        
    }
    
}
