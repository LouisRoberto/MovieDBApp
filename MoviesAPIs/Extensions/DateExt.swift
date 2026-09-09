//
//  DateExt.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import Foundation

enum DateFormats : String {
    case slashedDateFormat = "dd/MM/yyyy"
    case slashedDateTimeFormat = "dd/MM/yyyy, HH:mm:ss"
    case dashedDateFormat = "dd-MM-yyyy"
    case dashedDateTimeFormat = "dd-MM-yyyy HH:mm"
    case dayMonthFormat = "dd MMMM"
    case fullDayMonthYearFormat = "EEEE d MMMM"
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case searchParamFormat = "yyyyMMdd"
    case monthFormat = "MMMM"
    case monthYearFormat = "MM-yyyy"
    case slashedMonthYearFormat = "MM/yyyy"
    case dashedReversedDateFormat = "yyyy-MM-dd"
    case hourMinuteFormat = "HH:mm"
}

extension Date {
    func toString( format : DateFormats) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale.init(identifier: "fr_FR")
        return formatter.string(from: self)
    }
    
    func dateByAddingDays(_ days: Int) -> Date {
        addingTimeInterval(Double(days) * 24.0 * 3600.0)
    }
    
    
    var startOfMonth : Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
        
    var endOfMonth: Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    func subtractMonthFromToday(with month: Int) -> Date? {
        if let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -month, to: self) {
            return sixMonthsAgo
        } else {
            return nil
        }
    }
}
