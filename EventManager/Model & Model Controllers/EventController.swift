//
//  EventController.swift
//  EventManager
//
//  Created by James Hager on 4/1/22.
//

import CoreData

class EventController {
    
    static let shared = EventController()
    
    var events = [Event]()
    
    private var sortBy: SortBy = .name
    
    private lazy var fetchRequest: NSFetchRequest<Event> = {
        let request = NSFetchRequest<Event>(entityName: Strings.eventEntityName)
        request.sortDescriptors = [SortBy.name.sortDescriptor]
        return request
    }()
    
    // MARK: - Init
    
    private init() {
        fetchEvents()
    }

    // MARK: - CRUD
    
    func createEvent(name: String, date: Date, alarm1Day: Bool, alarm1Hour: Bool, alarm1Week: Bool, alarmAtEvent: Bool) {
        let event = Event(name: name, date: date, alarm1Day: alarm1Day, alarm1Hour: alarm1Hour, alarm1Week: alarm1Week, alarmAtEvent: alarmAtEvent)
        CoreDataStack.saveContext()
        fetchEvents()
        
        if alarm1Day {
            NotificationManager.addNotification(for: event, at: .oneDay)
        }
        
        if alarm1Hour {
            NotificationManager.addNotification(for: event, at: .oneHour)
        }
        
        if alarm1Week {
            NotificationManager.addNotification(for: event, at: .oneWeek)
        }
        
        if alarmAtEvent {
            NotificationManager.addNotification(for: event, at: .atEvent)
        }
    }
    
    func fetchEvents() {
        do {
            events = try CoreDataStack.context.fetch(fetchRequest)
        } catch {
            print("Error fetching events: \(error.localizedDescription)")
        }
    }
    
    func setSortBy(to sortBy: SortBy) {
        self.sortBy = sortBy
        fetchRequest.sortDescriptors = [sortBy.sortDescriptor]
        fetchEvents()
    }
    
    func update(_ event: Event, name: String, date: Date, alarm1Day: Bool, alarm1Hour: Bool, alarm1Week: Bool, alarmAtEvent: Bool) {
        let nameChanged = name != event.name
        let dateChanged = date != event.date
        
        let previousAlarm1Day = event.alarm1Day
        let previousAlarm1Hour = event.alarm1Hour
        let previousAlarm1Week = event.alarm1Week
        let previousAlarmAtEvent = event.alarmAtEvent
        
        event.set(name: name, date: date, alarm1Day: alarm1Day, alarm1Hour: alarm1Hour, alarm1Week: alarm1Week, alarmAtEvent: alarmAtEvent)
        CoreDataStack.saveContext()
        
        if (sortBy == .name && nameChanged) || (sortBy == .date && dateChanged) {
            fetchEvents()
        }
        
        updateNotification(for: event, dateChanged: dateChanged, alarm: alarm1Day, previousAlarm: previousAlarm1Day, at: .oneDay)
        updateNotification(for: event, dateChanged: dateChanged, alarm: alarm1Hour, previousAlarm: previousAlarm1Hour, at: .oneHour)
        updateNotification(for: event, dateChanged: dateChanged, alarm: alarm1Week, previousAlarm: previousAlarm1Week, at: .oneWeek)
        updateNotification(for: event, dateChanged: dateChanged, alarm: alarmAtEvent, previousAlarm: previousAlarmAtEvent, at: .atEvent)
    }
    
    func updateNotification(for event: Event, dateChanged: Bool, alarm: Bool, previousAlarm: Bool, at eventNotificationTime: EventNotificationTime) {
        
        if dateChanged && previousAlarm {
            NotificationManager.removeNotification(for: event, at: eventNotificationTime)
        }
        
        if alarm {
            NotificationManager.addNotification(for: event, at: eventNotificationTime)
        }
    }
    
    func toggleIsAttendingForEvent(atIndex index: Int) {
        events[index].isAttending.toggle()
        CoreDataStack.saveContext()
    }
    
    func deleteEvent(atIndex index: Int) {
        let event = events[index]
        NotificationManager.removeNotifications(for: event)
        CoreDataStack.context.delete(event)
        events.remove(at: index)
        CoreDataStack.saveContext()
    }
}
