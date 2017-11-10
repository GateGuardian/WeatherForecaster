//
//  DateFormating.swift
//  WeatherForecaster
//
//  Created by Evan Kostromin on 11/10/17.
//  Copyright © 2017 ivan.kostromin.com. All rights reserved.
//

import Foundation

struct DateFormatters {
    static let WeekDayDateFormatter: DateFormatter = weekDayDateFormatter()
    static let FullDateFormatter: DateFormatter = fullDateFormatter()
    
    private static func weekDayDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }
    
    private static func fullDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM dd yyyy"
        return dateFormatter
    }
}

//TODO: create separate extension

extension Date {
    var isToday: Bool { return NSCalendar.current.isDateInToday(self) }
    
    func weekDay() -> String {
        return DateFormatters.WeekDayDateFormatter.string(from: self).capitalized
    }
    
    func fullDate() -> String {
        return DateFormatters.FullDateFormatter.string(from: self).capitalized
    }
}


