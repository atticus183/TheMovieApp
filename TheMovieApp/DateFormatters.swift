//
//  DateFormatters.swift
//  TheMovieApp
//
//  Created by Josh R on 1/2/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import Foundation

struct DateFormatters {
    //for converting date strings in the following format:  yyyy-mm-dd
    static func toDate(from stringDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: stringDate) ?? nil
    }
    
    static func changeStringDateFormat(from stringDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateObject = dateFormatter.date(from: stringDate) ?? nil
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = .medium
        dateFormatter2.locale = Locale.current
        dateFormatter2.calendar = .current  //this will automatically detect if the user's device is using 24 hour or AM/PM
        
        return dateFormatter2.string(from: dateObject ?? Date())
    }
    
    static func convertZTime(zStringDate: String?) -> String {
        guard let zStringDate = zStringDate else { return "Not Available"}
         
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let formattedDate = dateFormatter.date(from: zStringDate)
        
        let dateFormatter2 = DateFormatter()
    //    dateFormatter2.dateFormat = "yyyy-MM-dd"
        dateFormatter2.dateStyle = .medium
        dateFormatter2.timeZone = TimeZone(abbreviation: "UTC")
        
        return dateFormatter2.string(from: ((formattedDate ?? nil) ?? nil)!)
    }
}
