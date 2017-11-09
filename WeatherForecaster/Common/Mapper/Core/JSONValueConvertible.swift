//
//  JSONValueConvertible.swift
//  Mapper
//
//  Created by Sauron Black on 1/7/16.
//  Copyright © 2016 Mordor. All rights reserved.
//

import Foundation

public protocol JSONValueConvertible {

	static func makeInstance(_ jsonValue: Any, context: Any?) -> Self?
	func jsonValue(_ context: Any?) -> Any?

}

extension Bool: JSONValueConvertible {

	public static func makeInstance(_ jsonValue: Any, context: Any? = nil) -> Bool? {
		if let value = jsonValue as? Bool {
			return value
		} else if let string = jsonValue as? NSString {
			return string.boolValue
		}
		return nil
	}

	public func jsonValue(_ context: Any? = nil) -> Any? {
		return self as NSNumber
	}

}

extension String: JSONValueConvertible {

	public static func makeInstance(_ jsonValue: Any, context: Any? = nil) -> String? {
		if let string = jsonValue as? String {
			return string
		} else if let number = jsonValue as? NSNumber {
			return String(describing: number)
		}
		return nil
	}

	public func jsonValue(_ context: Any? = nil) -> Any? {
		return self as NSString
	}
	
}

extension NSNumber: JSONValueConvertible {

	public static func makeInstance(_ jsonValue: Any, context: Any? = nil) -> Self? {
		if let number = jsonValue as? NSNumber {
            return self.init(value: number.doubleValue)
		} else if let string = jsonValue as? String {
			let numberFormatter = NumberFormatter()
			numberFormatter.numberStyle = .decimal
			if let double = numberFormatter.number(from: string)?.doubleValue {
				return self.init(value: double)
			}
		}
		return nil
	}

	public func jsonValue(_ context: Any? = nil) -> Any? {
		return self
	}

}

extension URL: JSONValueConvertible {

	public static func makeInstance(_ jsonValue: Any, context: Any? = nil) -> URL? {
		if let string = jsonValue as? String {
			return URL(string: string)
		}
		return nil
	}

	public func jsonValue(_ context: Any? = nil) -> Any? {
		return absoluteString
	}

}

extension Date: JSONValueConvertible {

	private static var ISO8601DateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
		return formatter
	}

	public static func makeInstance(_ jsonValue: Any, context: Any? = nil) -> Date? {
		if let dateString = jsonValue as? String {
			return ISO8601DateFormatter.date(from: dateString)
		}
		return nil
	}

	public func jsonValue(_ context: Any? = nil) -> Any? {
		return Date.ISO8601DateFormatter.string(from: self)
	}

}
