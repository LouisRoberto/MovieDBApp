//
//  StringExt.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import Foundation

extension String {
    
    func toDate(format: DateFormats, locale : String = "fr_FR") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale.init(identifier: locale)
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func changeFormat( format : DateFormats) -> String {
        guard let dateFromat = self.toDate(format: format) else { return self }
        return dateFromat.toString(format: format)
    }
    
    func changeFormat( from oldFromat: DateFormats, to newFormat: DateFormats) -> String {
        guard let dateFromat = self.toDate(format: oldFromat) else { return self }
        return dateFromat.toString(format: newFormat)
    }
}
