//
//  DateEntity.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/9/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

struct DateEntity {
    fileprivate(set) var timeInterval: TimeInterval
    fileprivate(set) var weekDay: String
    fileprivate(set) var date: Date
}

extension DateEntity: Mappable {
    
    init() {
        self.init(timeInterval: 0.0, weekDay: "", date: Date())
    }
    
    static func makeInstance(_ map: Map) -> DateEntity? {
        return DateEntity()
    }
    
    mutating func map(with map: Map) {
        
        let keys = map.context as? [String : String]
        map.bind(&timeInterval, key: keys?[MappingKeysDefault.timeInterval] ?? MappingKeysDefault.timeInterval)
        map.bind(&weekDay, key: keys?[MappingKeysDefault.weekDay] ?? MappingKeysDefault.weekDay)
        map.bind(&date, key: keys?[MappingKeysDefault.date] ?? MappingKeysDefault.date)
        
    }
}

extension DateEntity {
    
    enum MappingKeysDefault {
        static let timeInterval = "epoch"
        static let weekDay = "weekday"
        static let date = "pretty"
    }
    
    enum MappingKeysCustom {
        static let currentConditionsKeys = [MappingKeysDefault.timeInterval : "local_epoch", MappingKeysDefault.weekDay : "", MappingKeysDefault.date : "local_time_rfc822"]
        
    }
    
}
