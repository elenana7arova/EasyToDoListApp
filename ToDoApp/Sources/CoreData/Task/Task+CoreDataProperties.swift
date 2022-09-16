//
//  Task+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 12.09.2022.
//
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String
    @NSManaged public var created: Date
    @NSManaged public var isDone: Bool

}

extension Task: Identifiable {

}
