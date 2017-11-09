//
//  ResponseData.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/8/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

struct ResponseData<T: JSONValueConvertible> {
    
    fileprivate(set) var content: ResponseDataContent<T>?
    
}

extension ResponseData: Mappable {
    
    static func makeInstance(_ map: Map) -> ResponseData<T>? {
        let rootKey = (map.context as? ResponseDataMappingContext)?.rootKey
        guard isValid(map.json, rootKey: rootKey) else { return nil }
        return ResponseData<T>()
    }
    
    static func isValid(_ json: [String: Any], rootKey: String?) -> Bool {
        var contentJSON: Any = json
        if let rootKey = rootKey, let rootJSON = json[rootKey] {
            contentJSON = rootJSON
        }
        guard ResponseDataContent<T>.isValid(contentJSON) else { return false }
        return true
    }
    
    mutating func map(with map: Map) {
        if let context = map.context as? ResponseDataMappingContext, let keyTuple = self.mappingKey(fromMappingContext: context) {
            map.bind(&content, key: keyTuple.key, isKeyPath: keyTuple.isKeyPath)
        } else {
            //TODO: case when no root key
            //default behaviour
            map.bind(&content, key: ResponseDataKey.content)
        }
    }
    
    private func mappingKey(fromMappingContext context: ResponseDataMappingContext) -> (key: String, isKeyPath: Bool)? {
        guard let rootKey = context.rootKey else {
            return nil
        }
        if let embeddedContentKey = context.embeddedContentKey {
            return (rootKey + "." + embeddedContentKey, true)
        } else {
            return (rootKey, false)
        }
    }
}

private enum ResponseDataKey {
    
    static let content = "data"
    
}

enum ResponseDataContent<T: JSONValueConvertible> {
    case anItem(T)
    case items([T])
}

extension ResponseDataContent: JSONValueConvertible {
    
    static func isValid(_ json: Any) -> Bool {
        return json is [Any] || json is [String: Any]
    }
    
    static func makeInstance(_ jsonValue: Any, context: Any?) -> ResponseDataContent<T>? {
        if let jsons = jsonValue as? [Any] {
            let items = jsons.flatMap { T.makeInstance($0, context: context) }
            return .items(items)
        } else if let json = jsonValue as? [String : Any], let item = T.makeInstance(json, context: context) {
            return .anItem(item)
        }
        return nil
    }
    
    func jsonValue(_ context: Any?) -> Any? {
        return nil
    }
    
}

struct ResponseDataMappingContext {
    
    let rootKey: String?
    let embeddedContentKey: String?
    
}
