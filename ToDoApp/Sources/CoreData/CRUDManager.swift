//
//  CRUDManager.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 14.09.2022.
//

import UIKit
import CoreData

final class CRUDManager {
    
    private var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    /// Метод для создания нового объекта заданного типа.
    /// - Parameters: 
    ///     - type:  Тип.
    ///     - keyValue:  Словарь ключ-значение.
    func create(ofType type: AnyClass, withKeyValue keyValue: [String: Any]) {
        guard let context = self.context else { return }
        
        if let object = type as? NSManagedObject.Type {
            let newObject = object.init(context: context)
            keyValue.forEach { key, value in 
                newObject.setValue(value, forKey: key)
            }
        }
        
        self.save(context: context)
    }
    
    /// Метод, возвращающий массив из всех хранящихся в хранилище объектов заданного типа.
    /// - Parameters: 
    ///     - type:  Тип.
    func allItems(ofType type: AnyClass) -> [NSFetchRequestResult] {
        guard let context = self.context else { return [] }

        do {
            let items = try context.fetch(type.fetchRequest())
            return items
        } catch {
            print("error", error)
        }
        return []
    }
    
    /// Метод для обновления объекта.
    /// - Parameters: 
    ///     - object:  Объект, требущий обновления.
    ///     - keyValue:  Словарь ключ-значение.
    func update(_ object: NSManagedObject, withKeyValue keyValue: [String: Any]) {
        guard let context = self.context else { return }
        
        keyValue.forEach { key, value in 
            object.setValue(value, forKey: key)
        }
        
        self.save(context: context)
    }
    
    /// Метод для удаления объекта.
    /// - Parameters: 
    ///     - object:  Объект, требущий удаления.
    func delete(_ object: NSManagedObject) {
        guard let context = self.context else { return }
        context.delete(object)
        
        self.save(context: context)
    }
    
    // MARK: - Private
    
    private func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("error", error)
        }
    }
}
