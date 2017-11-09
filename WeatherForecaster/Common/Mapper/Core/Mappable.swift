//
//  Mappable.swift
//  Mapper
//
//  Created by Sauron Black on 1/7/16.
//  Copyright © 2016 Mordor. All rights reserved.
//

import Foundation

public protocol Mappable: JSONValueConvertible {

	static func makeInstance(_ map: Map) -> Self?
	mutating func map(with map: Map)
	
}

extension Mappable {

    public static func makeInstance(_ jsonValue: Any, context: Any? = nil) -> Self? {
        guard let json = jsonValue as? [String: Any] else { return nil }
        return Self.makeInstance(json, context: context)
    }

    public func jsonValue(_ context: Any? = nil) -> Any? {
        return self.jsonObject(context)
    }

    public static func makeInstance(_ json: [String: Any], context: Any? = nil) -> Self? {
        let map = Map(json: json, direction: .fromJSON, context: context)
        guard var object = Self.makeInstance(map) else { return nil }
        object.map(with: map)
        return object
    }


	public func jsonObject(_ context: Any? = nil) -> [String: Any] {
		let map = Map(direction: .toJSON, context: context)
		var muttableObject = self
        muttableObject.map(with: map)
		return map.json
	}

}
