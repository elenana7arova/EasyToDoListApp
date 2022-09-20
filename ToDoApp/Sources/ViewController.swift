//
//  ViewController.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 12.09.2022.
//

import UIKit
import CoreData

final class ViewController: UIViewController {
    typealias Closure = () -> Void
    
    private var tableView: UITableView?
    private let crudManager = CRUDManager()
    private var categories = [Category]()
    private enum Constants {
        enum String {
            static let title = "Main.title".localized
            static let cellID = "CellID"
            static let cancelTitle = "Common.cancelTitle".localized
            static let okTitle = "Common.okTitle".localized
            static let yesTitle = "Common.yesTitle".localized
            static let create = "Common.createTitle".localized
            static let update = "Common.updateTitle".localized
            static let remove = "Common.removeTitle".localized
            static let confirmation = "Common.сonfirmationTitle".localized
            static let task = "Task.title".localized
            static let category = "Category.title".localized
            static let createOptions = "Common.creationOptions".localized
            static let categoryOptions = "Category.options".localized
            static let chooseCategory = "Category.choose".localized
            static let chooseNewCategory = "Category.chooseNew".localized
            static let categoryDisclaimer = "Category.disclaimer".localized
        }
        enum Image {
            static let addImage = UIImage(systemName: "plus")!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.categories = crudManager.allItems(ofType: Category.self) as! [Category]
        self.setupNav()
        self.createTable()
    }
    
    // MARK: - UI
    
    private func setupNav() {
        self.title = Constants.String.title
        
        let addButton = UIBarButtonItem(image: Constants.Image.addImage, 
                                        style: .plain, 
                                        target: self, 
                                        action: #selector(self.addButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }

    private func createTable() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: Constants.String.cellID)
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(tableView)
        self.tableView = tableView
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateTable() {
        let categories = crudManager.allItems(ofType: Category.self) as! [Category]
        self.categories = categories.sorted(by: { $0.created < $1.created })
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc 
    private func addButtonPressed(_ sender: UIBarButtonItem) {
        self.showAlertWithActionsAndCancelAction(title: Constants.String.createOptions, actions: [
            Action(title: Constants.String.task.capitalized) { [weak self] in
                self?.createObject(of: .task)
            },
            Action(title: Constants.String.category.capitalized) { [weak self] in
                self?.createObject(of: .category)
            }
        ])
    }
    
    private func pressHeaderView(on category: Category) {
        self.showAlertWithActionsAndCancelAction(title: Constants.String.categoryOptions, 
                                                 actions: [
                                                    Action(title: Constants.String.update) { [weak self] in
                                                        self?.updateObject(category)
                                                    },
                                                    Action(title: Constants.String.remove) { [weak self] in
                                                        self?.removeObject(category)
                                                    },
                                                 ])
    }
    
    private func createObject(of type: ObjectType) {
        var title: String = "\(Constants.String.create) "
        switch type {
            case .task:
                title.append(Constants.String.task.lowercased())
            case .category:
                title.append(Constants.String.category.lowercased())
        }
        
        self.showAlertWithTextfield(title: title) { name in
            switch type {
                case .category:
                    self.crudManager.create(ofType: Category.self, withKeyValue: [
                        "name": name,
                        "created": Date(),
                        "tasks": NSSet(array: [])
                    ])
                    self.updateTable()
                case .task:
                    self.showAlertWithSheetOfActions(title: Constants.String.chooseCategory, 
                                                     objects: self.categories) { category in
                        self.crudManager.create(ofType: Task.self, withKeyValue: [
                            "name": name,
                            "isDone": false,
                            "created": Date(),
                            "category": category,
                        ]) 
                        self.updateTable()
                    }
            }
        }
    }
    
    private func updateObject<T: ObjectWithName>(_ object: T) {
        guard let type = ObjectType(object) else { return }
        var title: String = "\(Constants.String.update) "
        
        switch type {
            case .category:
                title.append(Constants.String.category.lowercased())
            case .task:
                title.append(Constants.String.task.lowercased())
        }
        self.showAlertWithTextfield(title: title, placeholder: object.name) { name in
            switch type {
                case .category:
                    self.crudManager.update(object, withKeyValue: ["name": name])
                    self.updateTable()
                case .task:
                    self.showAlertWithSheetOfActions(title: Constants.String.chooseNewCategory, 
                                                     objects: self.categories) { category in
                        self.crudManager.update(object, withKeyValue: [
                            "name": name,
                            "category": category
                        ])
                        self.updateTable()
                    }
            }
        }
    }
    
    private func checkmarkTask(_ item: Task, isDone: Bool) {
        self.crudManager.update(item, withKeyValue: ["isDone": isDone])
    }
    
    private func removeObject<T: ObjectWithName>(_ object: T) {
        guard let type = ObjectType(object) else { return }
        var title: String = "\(Constants.String.confirmation) \(Constants.String.remove.lowercased()) "
        
        switch type {
            case .category:
                title.append(Constants.String.category.lowercased())
            case .task:
                title.append(Constants.String.task.lowercased())
        }
        self.showAlertWithActionsAndCancelAction(title: title, actions: [
            Action(title: Constants.String.yesTitle) { [weak self] in
                self?.crudManager.delete(object)
                self?.updateTable()
            }
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = self.categories[section]
        let action: Closure? = section == 0 ? { [weak self] in self?.showDisclaimerAlert(title: Constants.String.categoryDisclaimer) }
                                            : { [weak self] in self?.pressHeaderView(on: category) }
        let view = ClickableHeaderView(title: category.name, action: action)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.String.cellID, for: indexPath) as! TaskTableViewCell
        guard var tasks = self.categories[indexPath.section].tasks.allObjects as? [Task] else { return cell }
        tasks = tasks.sorted(by: { $0.created < $1.created })
        let task = tasks[indexPath.row]
        cell.title = task.name
        cell.isDone = task.isDone
        cell.trashAction = { [weak self] in self?.removeObject(task) }
        cell.actions.done = { [weak self] in self?.checkmarkTask(task, isDone: true) }
        cell.actions.undone = { [weak self] in self?.checkmarkTask(task, isDone: false) }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard var tasks = self.categories[indexPath.section].tasks.allObjects as? [Task] else { return }
        tasks = tasks.sorted(by: { $0.created < $1.created })
        let task = tasks[indexPath.row]
        self.updateObject(task)
    }
}
