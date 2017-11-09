//
//  Map.swift
//  Mapper
//
//  Created by Sauron Black on 1/7/16.
//  Copyright © 2016 Mordor. All rights reserved.
//

import Foundation

public final class Map {

	public private(set) var json: [String: Any]
	public private(set) var direction: Direction
	public private(set) var context: Any?
	public var mapNilToNSNull = false

	public init(json: [String: Any], direction: Direction, context: Any?) {
		self.json = json
		self.direction = direction
		self.context = context
	}

	public func bind<C: JSONValueConvertible>(_ property: inout C, key: String, isKeyPath: Bool = false) {
		switch direction {
		case .fromJSON:
			if let jsonValue = valueFor(key, isKeyPath: isKeyPath), let convertedValue = C.makeInstance(jsonValue, context: context) {
				property = convertedValue
			}
		case .toJSON:
			if !isKeyPath {
				json[key] = property.jsonValue(context)
			}
		}
	}

	public func bind<C: JSONValueConvertible>(_ property: inout C?, key: String, isKeyPath: Bool = false) {
		switch direction {
		case .fromJSON:
			if let jsonValue = valueFor(key, isKeyPath: isKeyPath), let convertedValue = C.makeInstance(jsonValue, context: context) {
				property = convertedValue
			}
		case .toJSON:
			if !isKeyPath {
				if let property = property {
					json[key] = property.jsonValue(context)
				} else if mapNilToNSNull {
					json[key] = NSNull()
				}
			}
		}
	}

    public func bind<M: Mappable>(_ property: inout M, key: String, isKeyPath: Bool = false) {
        switch direction {
        case .fromJSON:
            if let json = valueFor(key, isKeyPath: isKeyPath) as? [String: Any], let convertedValue = M.makeInstance(json, context: context) {
                property = convertedValue
            }
        case .toJSON:
            if !isKeyPath {
                json[key] = property.jsonObject(context)
            }
        }
    }

    public func bind<M: Mappable>(_ property: inout M?, key: String, isKeyPath: Bool = false) {
        switch direction {
        case .fromJSON:
            if let json = valueFor(key, isKeyPath: isKeyPath) as? [String: Any], let convertedValue = M.makeInstance(json, context: context) {
                property = convertedValue
            }
        case .toJSON:
			if !isKeyPath {
				if let property = property {
					json[key] = property.jsonObject(context)
				} else if mapNilToNSNull {
					json[key] = NSNull()
				}
			}
        }
    }
    
    public func bind<T: JSONValueTransformer>(_ property: inout T.Object, key: String, isKeyPath: Bool = false, transformer: T) {
        switch direction {
        case .fromJSON:
            if let jsonValue = valueFor(key, isKeyPath: isKeyPath), let value = transformer.object(from: jsonValue) {
                property = value
            }
        case .toJSON:
            if !isKeyPath {
                json[key] = transformer.jsonValue(from: property)
            }
        }
    }
    
    public func bind<T: JSONValueTransformer>(_ property: inout T.Object?, key: String, isKeyPath: Bool = false, transformer: T) {
        switch direction {
        case .fromJSON:
            if let jsonValue = valueFor(key, isKeyPath: isKeyPath), let value = transformer.object(from: jsonValue) {
                property = value
            }
        case .toJSON:
            if !isKeyPath {
                if let property = property {
                    json[key] = transformer.jsonValue(from: property)
                } else if mapNilToNSNull {
                    json[key] = NSNull()
                }
            }
        }
    }

	public func bind<CC: JSONValueConvertibleContainer>(_ property: inout CC, key: String, isKeyPath: Bool = false) where CC.Item: JSONValueConvertible, CC.Iterator.Element: JSONValueConvertible {
		switch direction {
		case .fromJSON:
			if let jsonValue = valueFor(key, isKeyPath: isKeyPath) as? [Any] {
				property = CC.makeInstance(jsonValue, context: context)
			}
		case .toJSON:
			if !isKeyPath {
				json[key] = property.jsonValue(context)
			}
		}
	}

	public func bind<CC: JSONValueConvertibleContainer>(_ property: inout CC?, key: String, isKeyPath: Bool = false) where CC.Item: JSONValueConvertible, CC.Iterator.Element: JSONValueConvertible {
		switch direction {
		case .fromJSON:
			if let jsonValue = valueFor(key, isKeyPath: isKeyPath) as? [Any] {
				property = CC.makeInstance(jsonValue, context: context)
			}
		case .toJSON:
			if !isKeyPath {
				if let property = property {
					json[key] = property.jsonValue(context)
				} else if mapNilToNSNull {
					json[key] = NSNull()
				}
			}
		}
	}

    public func bind<CM: JSONValueConvertibleContainer>(_ property: inout CM, key: String, isKeyPath: Bool = false) where CM.Item: Mappable, CM.Iterator.Element: Mappable {
        switch direction {
        case .fromJSON:
            if let jsonValue = valueFor(key, isKeyPath: isKeyPath) as? [[String: Any]]  {
                property = CM.makeInstance(jsonValue, context: context)
            }
        case .toJSON:
            if !isKeyPath {
                json[key] = property.jsonValue(context)
            }
        }
    }

    public func bind<CM: JSONValueConvertibleContainer>(_ property: inout CM?, key: String, isKeyPath: Bool = false) where CM.Item: Mappable, CM.Iterator.Element: Mappable {
        switch direction {
        case .fromJSON:
            if let jsonValue = valueFor(key, isKeyPath: isKeyPath) as? [[String: Any]] {
                property =  CM.makeInstance(jsonValue, context: context)
            }
        case .toJSON:
			if !isKeyPath {
				if let property = property {
					json[key] = property.jsonValue(context)
				} else if mapNilToNSNull {
					json[key] = NSNull()
				}
			}
        }
    }

	public func bind<C: JSONValueConvertibleContainer, T: JSONValueTransformer>(_ property: inout C, key: String, isKeyPath: Bool = false, transformer: T) where C.Item == T.Object, C.Iterator.Element == T.Object {
		switch direction {
		case .fromJSON:
			if let jsonValue = valueFor(key, isKeyPath: isKeyPath) as? [Any] {
				property = C.makeInstance(jsonValue, transformer: transformer)
			}
		case .toJSON:
			if !isKeyPath {
				json[key] = property.jsonValue(transformer)
			}
		}
	}

	public func bind<C: JSONValueConvertibleContainer, T: JSONValueTransformer>(_ property: inout C?, key: String, isKeyPath: Bool = false, transformer: T) where C.Item == T.Object, C.Iterator.Element == T.Object {
		switch direction {
		case .fromJSON:
			if let jsonValue = valueFor(key, isKeyPath: isKeyPath) as? [Any] {
				property = C.makeInstance(jsonValue, transformer: transformer) 
			}
		case .toJSON:
			if !isKeyPath {
				if let property = property {
					json[key] = property.jsonValue(transformer)
				} else if mapNilToNSNull {
					json[key] = NSNull()
				}
			}
		}
	}

	fileprivate func valueFor(_ key: String, isKeyPath: Bool) -> Any? {
		return !isKeyPath ? json[key] : json.valueFor(key)
	}
}

extension Map {

	public enum Direction {
		case toJSON
		case fromJSON
	}

}

extension Map {

	public convenience init(direction: Direction, context: Any?) {
		self.init(json: [:], direction: direction, context: context)
	}

}

protocol StringProtocol {}

extension String: StringProtocol {}

extension Dictionary where Key: StringProtocol, Value: Any {

    func valueFor(_ keyPath: String) -> Any? {
		guard !keyPath.isEmpty else { return nil }

		var value: Any?
		var keyPathComponets = keyPath.components(separatedBy: ".")
		if let key = keyPathComponets.first as? Key {
			keyPathComponets.removeFirst()
			value = self[key]
		}

		for key in keyPathComponets {
			if let dictionary = value as? [String: Any] {
				value = dictionary[key]
			} else if let array = value as? [Any], let index = Int(key) , index < array.count && index >= 0 {
				value = array[index]
			} else {
				return nil
			}
        }
        return value
	}
	
}
