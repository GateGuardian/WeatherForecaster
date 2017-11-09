//
//  JSONValueConvertibleRawRepresentable.swift
//  Mapper
//
//  Created by Sauron Black on 6/11/16.
//  Copyright © 2016 Mordor. All rights reserved.
//

import Foundation

public protocol JSONValueConvertibleRawRepresentable: RawRepresentable, JSONValueConvertible {
}

extension JSONValueConvertibleRawRepresentable where RawValue: JSONValueConvertible {

	public static func makeInstance(_ jsonValue: Any, context: Any?) -> Self? {
		if let rawValue = RawValue.makeInstance(jsonValue, context: context) {
			return self.init(rawValue: rawValue)
		}
		return nil
	}

	public func jsonValue(_ context: Any?) -> Any? {
		return rawValue.jsonValue(context)
	}

}
