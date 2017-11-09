//
//  JSONValueConvertibleFloatingPointType.swift
//  Mapper
//
//  Created by Sauron Black on 1/16/16.
//  Copyright © 2016 Mordor. All rights reserved.
//

import Foundation

public protocol JSONValueConvertibleFloatingPointType: JSONValueConvertible {

	init?(_ text: String)

}

extension JSONValueConvertibleFloatingPointType {

	public static func makeInstance(_ jsonValue: Any, context: Any? = nil) -> Self? {
		if let number = jsonValue as? Self {
			return number
		} else if let string = jsonValue as? String {
			return Self(string)
		}
		return nil
	}
    
    public func jsonValue(_ context: Any? = nil) -> Any? {
        return self as? NSNumber
    }

}

extension Float: JSONValueConvertibleFloatingPointType {}

extension Double: JSONValueConvertibleFloatingPointType {}
