//
//  JSONValueConvertibleContainer.swift
//  Mapper
//
//  Created by Sauron Black on 1/16/16.
//  Copyright © 2016 Mordor. All rights reserved.
//

import Foundation

public protocol JSONValueConvertibleContainer: Sequence {

	associatedtype Item

	init<S : Sequence>(_ sequence: S) where S.Iterator.Element == Item

}

extension JSONValueConvertibleContainer where Item: JSONValueConvertible, Iterator.Element: JSONValueConvertible {

	public static func makeInstance(_ jsonValues: [Any], context: Any? = nil) -> Self {
        return Self(jsonValues.flatMap { Item.makeInstance($0, context: context) })
	}

	public func jsonValue(_ context: Any? = nil) -> [Any] {
        return flatMap { $0.jsonValue(context) }
	}

}

extension JSONValueConvertibleContainer where Item: Mappable, Iterator.Element: Mappable {

    public static func makeInstance(_ jsons: [[String: Any]], context: Any? = nil) -> Self {
        return Self(jsons.flatMap { Item.makeInstance($0, context: context) })
    }

    public func jsonValue(_ context: Any? = nil) -> [[String: Any]] {
        return map { $0.jsonObject(context) }
    }
    
}

extension JSONValueConvertibleContainer {

	public static func makeInstance<T: JSONValueTransformer>(_ jsonValues: [Any], transformer: T) -> Self where T.Object == Item {
        return Self(jsonValues.flatMap { transformer.object(from: $0) })
	}

	public func jsonValue<T: JSONValueTransformer>(_ transformer: T) -> [Any] where T.Object == Iterator.Element {
        return flatMap { transformer.jsonValue(from: $0) }
	}

}

extension Array: JSONValueConvertibleContainer {

	public typealias Item = Element

}

extension Set: JSONValueConvertibleContainer {

	public typealias Item = Element
	
}
