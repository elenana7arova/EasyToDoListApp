//
//  ObjectType.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 20.09.2022.
//

import Foundation

enum ObjectType {
    case task
    case category
    
    init?<T: ObjectWithName>(_ object: T?) {
        switch object {
            case object as Category:
                self = .category
            case object as Task:
                self = .task
            default: 
                return nil
        }
    }
}
