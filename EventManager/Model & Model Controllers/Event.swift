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
    
    @NSManaged var date: Date
    @NSManaged var isAttending: Bool
    @NSManaged var name: String
    
    // MARK: - Properties
    
    var id: String { objectID.uriRepresentation().absoluteString }
    
    // MARK: - Init
    
    @discardableResult convenience init(name: String, date: Date, isAttending: Bool = true, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        set(name: name, date: date, isAttending: isAttending)
    }
    
    // MARK: - Methods
    
    func set(name: String, date: Date, isAttending: Bool? = nil) {
        self.name = name
        self.date = date
        
        if let isAttending = isAttending {
            self.isAttending = isAttending
        }
    }
}
