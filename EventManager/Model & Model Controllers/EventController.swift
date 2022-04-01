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
    
    lazy var fetchRequest: NSFetchRequest<Event> = {
        let request = NSFetchRequest<Event>(entityName: Strings.eventEntityName)
        request.sortDescriptors = [NSSortDescriptor(key: Strings.nameKey, ascending: true)]
        return request
    }()
    
    private init() {
        fetchEvents()
    }
    
    // MARK: - CRUD
    
    func createEvent(name: String, date: Date) {
        Event(name: name, date: date)
        CoreDataStack.saveContext()
        fetchEvents()
    }
    
    func fetchEvents() {
        do {
            events = try CoreDataStack.context.fetch(fetchRequest)
        } catch {
            print("Error fetching events: \(error.localizedDescription)")
        }
    }
    
    func update(_ event: Event, name: String, date: Date) {
        let previousName = event.name
        event.set(name: name, date: date)
        CoreDataStack.saveContext()
        
        if name != previousName {
            fetchEvents()
        }
    }
    
    func toggleIsAttendingForEvent(atIndex index: Int) {
        events[index].isAttending.toggle()
        CoreDataStack.saveContext()
    }
    
    func deleteEvent(atIndex index: Int) {
        CoreDataStack.context.delete(events[index])
        events.remove(at: index)
        CoreDataStack.saveContext()
    }
}
