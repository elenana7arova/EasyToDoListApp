//
//  ObjectWithName.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 20.09.2022.
//

import Foundation
import CoreData

protocol ObjectWithName: NSManagedObject {
    var name: String { get set }
}
