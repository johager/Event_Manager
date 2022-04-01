//
//  SortBy.swift
//  EventManager
//
//  Created by James Hager on 4/1/22.
//

import Foundation
import CoreData

enum SortBy: Int {
    case name = 0
    case date = 1
    
    var sortDescriptor: NSSortDescriptor {
        switch self {
        case .name:
            return NSSortDescriptor(key: Strings.nameKey, ascending: true)
        case .date:
            return NSSortDescriptor(key: Strings.dateKey, ascending: true)
        }
    }
}
