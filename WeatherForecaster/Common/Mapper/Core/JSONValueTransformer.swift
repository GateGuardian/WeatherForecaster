//
//  JSONValueTransformer.swift
//  Mapper
//
//  Created by Sauron Black on 1/7/16.
//  Copyright © 2016 Mordor. All rights reserved.
//

import Foundation

public protocol JSONValueTransformer {

	associatedtype Object

	func object(from jsonValue: Any) -> Object?
	func jsonValue(from object: Object) -> Any?

}
