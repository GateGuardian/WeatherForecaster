//
//  JSONValueConvertibleIntegerType.swift
//  Mapper
//
//  Created by Sauron Black on 1/16/16.
//  Copyright © 2016 Mordor. All rights reserved.
//

import Foundation

public protocol JSONValueConvertibleIntegerType: JSONValueConvertible {

	init?(_ text: String, radix: Int)

}

extension JSONValueConvertibleIntegerType {

	public static func makeInstance(_ jsonValue: Any, context: Any? = nil) -> Self? {
		if let number = jsonValue as? Self {
			return number
		} else if let string = jsonValue as? String {
			return Self(string, radix: 10)
		}
		return nil
	}
    
    public func jsonValue(_ context: Any? = nil) -> Any? {
        return self as? NSNumber
    }

}

extension Int: JSONValueConvertibleIntegerType {}
extension Int8: JSONValueConvertibleIntegerType {}
extension Int16: JSONValueConvertibleIntegerType {}
extension Int32: JSONValueConvertibleIntegerType {}
extension Int64: JSONValueConvertibleIntegerType {}
extension UInt: JSONValueConvertibleIntegerType {}
extension UInt8: JSONValueConvertibleIntegerType {}
extension UInt16: JSONValueConvertibleIntegerType {}
extension UInt32: JSONValueConvertibleIntegerType {}
extension UInt64: JSONValueConvertibleIntegerType {}
