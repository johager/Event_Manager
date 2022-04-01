//
//  Date+.swift
//  EventManager
//
//  Created by James Hager on 4/1/22.
//

import Foundation

extension Date {
    
    var stringForEventDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}
