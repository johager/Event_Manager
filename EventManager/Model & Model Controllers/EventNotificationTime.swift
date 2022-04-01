//
//  EventNotificationTime.swift
//  EventManager
//
//  Created by James Hager on 4/1/22.
//

import Foundation
import CoreData

enum EventNotificationTime: String, CaseIterable, CustomStringConvertible {
    case atEvent
    case oneHour
    case oneDay
    case oneWeek
    
    var description: String { return rawValue }
    
    // MARK: - Methods
    
    func notificationDate(for event: Event) -> Date? {
        switch self {
        case .atEvent:
            return event.date
        case .oneHour:
            return Calendar.current.date(byAdding: .hour, value: -1, to: event.date)
        case .oneDay:
            return Calendar.current.date(byAdding: .day, value: -1, to: event.date)
        case .oneWeek:
            return Calendar.current.date(byAdding: .day, value: -7, to: event.date)
        }
    }
    
    func notificationId(for event: Event) -> String {
        return event.id + description
    }
    
    func notificationInfo(for event: Event) -> (title: String, body: String) {
        switch self {
        case .atEvent:
            return ("⏰", "\(event.name) is now")
        case .oneHour:
            return ("Reminder", "\(event.name) is in one hour")
        case .oneDay:
            return ("Reminder", "\(event.name) is tomorrow")
        case .oneWeek:
            return ("Reminder", "\(event.name) is next week")
        }
    }
}
