//
//  Task+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 20.09.2022.
//
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var created: Date
    @NSManaged public var isDone: Bool
    @NSManaged public var name: String
    @NSManaged public var category: Category

}

extension Task : Identifiable {

}
