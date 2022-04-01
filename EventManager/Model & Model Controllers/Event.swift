//
//  Event.swift
//  EventManager
//
//  Created by James Hager on 4/1/22.
//

import CoreData

@objc(Event)
class Event: NSManagedObject {
    
    // MARK: - CoreData Properties
    
    @NSManaged var alarm1Day: Bool
    @NSManaged var alarm1Hour: Bool
    @NSManaged var alarm1Week: Bool
    @NSManaged var alarmAtEvent: Bool
    @NSManaged var date: Date
    @NSManaged var isAttending: Bool
    @NSManaged var name: String
    
    // MARK: - Properties
    
    var hasAlarm: Bool { alarm1Day || alarm1Hour || alarm1Week || alarmAtEvent}
    
    var id: String { objectID.uriRepresentation().absoluteString }
    
    // MARK: - Init
    
    @discardableResult convenience init(name: String, date: Date, alarm1Day: Bool, alarm1Hour: Bool, alarm1Week: Bool, alarmAtEvent: Bool, isAttending: Bool = true, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        set(name: name, date: date, alarm1Day: alarm1Day, alarm1Hour: alarm1Hour, alarm1Week: alarm1Week, alarmAtEvent: alarmAtEvent, isAttending: isAttending)
    }
    
    // MARK: - Methods
    
    func set(name: String, date: Date, alarm1Day: Bool, alarm1Hour: Bool, alarm1Week: Bool, alarmAtEvent: Bool, isAttending: Bool? = nil) {
        self.name = name
        self.date = date
        self.alarm1Day = alarm1Day
        self.alarm1Hour = alarm1Hour
        self.alarm1Week = alarm1Week
        self.alarmAtEvent = alarmAtEvent
        
        if let isAttending = isAttending {
            self.isAttending = isAttending
        }
    }
}
