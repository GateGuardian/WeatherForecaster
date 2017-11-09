//
//  ResponseError.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/8/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

struct ResponseError {
    
    fileprivate(set) var code: String
    fileprivate(set) var message: String
    fileprivate(set) var userInfo: [String: Any]?
    
}

extension ResponseError: Equatable {
    
    static func ==(lhs: ResponseError, rhs: ResponseError) -> Bool {
        return lhs.code == rhs.code && lhs.message == rhs.message
    }
    
}

extension ResponseError: Mappable {
    
    init() {
        self.init(code: "", message: "", userInfo: nil)
    }
    
    static func makeInstance(_ map: Map) -> ResponseError? {
        guard isValid(map.json) else { return nil }
        return ResponseError()
    }
    
    static func isValid(_ json: [String: Any]) -> Bool {
        guard let errorJSON = json[Keys.error] as? [String: Any],
            let code = errorJSON[Keys.code] as? String,
            let message = errorJSON[Keys.message] as? String,
            !code.isEmpty && !message.isEmpty else { return false }
        return true
    }
    
    mutating func map(with map: Map) {
        map.bind(&code, key: Keys.error + "." + Keys.code, isKeyPath: true)
        map.bind(&message, key: Keys.error + "." + Keys.message, isKeyPath: true)
        userInfo = map.json[Keys.userInfo] as? [String: Any]
    }
    
    private enum Keys {
        static let error = "error"
        static let code = "code"
        static let message = "message"
        static let userInfo = "data"
    }
    
}
