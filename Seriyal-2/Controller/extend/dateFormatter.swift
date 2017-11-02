//
//  dateFormatter.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 10. 30..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import Foundation

class CustomDateFormatter {
    
    // MARK: - Properties
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    // MARK: - Public
    static func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
    
    static func campare(_ string: String, with date: Date = Date()) -> Bool {
        guard let newDate = dateFormatter.date(from: string) else {
            return false
        }
        return newDate >= date
    }
}
