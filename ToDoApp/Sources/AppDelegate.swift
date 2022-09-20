//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 12.09.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let userDefaults = UserDefaults.standard
    private let crudManager = CRUDManager()
    private var isFirstLaunch: Bool {
        return self.userDefaults.bool(forKey: Constants.isFirstLaunchKey)
    }
    private enum Constants {
        static let isFirstLaunchKey = "isFirstLaunch"
        static let defaultCategoryName = "Category.default".localized
    }
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootController = ViewController()
        let navController = UINavigationController(rootViewController: rootController)
        navController.view.backgroundColor = .white
        navController.navigationBar.tintColor = .black
        navController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.setUserDefaults()
        self.createDefaultData()
        self.window = window
        return true
    }
    
    private func setUserDefaults() {
        guard !self.isFirstLaunch else { return }
        self.userDefaults.set(true, forKey: Constants.isFirstLaunchKey)
    }
    
    private func createDefaultData() {
        guard !self.isFirstLaunch else { return }
        self.crudManager.create(ofType: Category.self, withKeyValue: [
            "name": Constants.defaultCategoryName,
            "created": Date(),
            "tasks": NSSet(array: [])
        ])
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

