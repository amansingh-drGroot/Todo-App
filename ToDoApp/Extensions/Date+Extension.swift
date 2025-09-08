//
//  Date+Extension.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 08/09/25.
//

import Foundation

extension Date {
    
    static func time(from dateString: String,
                     inputFormat: String = "yyyy-MM-dd'T'HH:mm",
                     outputFormat: String = "HH:mm") -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.timeZone = TimeZone.current
        
        guard let date = inputFormatter.date(from: dateString) else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.timeZone = TimeZone.current
        
        return outputFormatter.string(from: date)
    }
}
