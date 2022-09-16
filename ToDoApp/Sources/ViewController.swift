//
//  ViewController.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 12.09.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private var tableView: UITableView?
    private let crudManager = CRUDManager()
    private var tasks = [Task]()
    private enum Constants {
        enum String {
            static let title = "Main.title".localized
            static let cellID = "CellID"
            static let cancelTitle = "Common.cancelTitle".localized
            static let okTitle = "Common.okTitle".localized
            static let yesTitle = "Common.yesTitle".localized
            static let createTask = "Task.createTitle".localized
            static let updateTask = "Task.updateTitle".localized
            static let deleteTaskConfirmation = "Task.removeConfirmationTitle".localized
        }
        enum Image {
            static let addImage = UIImage(systemName: "plus")!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tasks = crudManager.allItems(ofType: Task.self) as! [Task]
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
        let tasks = crudManager.allItems(ofType: Task.self) as! [Task]
        self.tasks = tasks.sorted(by: { $0.created < $1.created })
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
    private func showAlertWithTextfield(title: String, defaultTitle: String? = nil, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, 
                                      message: nil, 
                                      preferredStyle: .alert)
        alert.addTextField()
        guard let textField = alert.textFields?.first else { return }
        textField.text = defaultTitle ?? ""
        
        let doneAction = UIAlertAction(title: Constants.String.okTitle, style: .default) { _ in
            guard let text = textField.text,
                  !text.isEmpty else { return }
            textField.text = defaultTitle ?? ""
            completion(text)
        }
        let cancelAction = UIAlertAction(title: Constants.String.cancelTitle, style: .cancel)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    // MARK: - Button Actions
    
    @objc 
    private func addButtonPressed(_ sender: UIBarButtonItem) {
        self.showAlertWithTextfield(title: Constants.String.createTask) { text in
            self.crudManager.create(ofType: Task.self, withKeyValue: [
                "name": text,
                "isDone": false,
                "created": Date()
            ]) 
            self.updateTable()
        }
    }
    
    private func cellPressed(on item: Task) {
        self.showAlertWithTextfield(title: Constants.String.updateTask, defaultTitle: item.name) { text in
            self.crudManager.update(item, withKeyValue: ["name": text])
            self.updateTable()
        }
    }

    private func trashCellPressed(on item: Task) {
        let alert = UIAlertController(title: Constants.String.deleteTaskConfirmation, 
                                      message: nil, 
                                      preferredStyle: .alert)
        let doneAction = UIAlertAction(title: Constants.String.yesTitle, style: .default) { _ in
            self.crudManager.delete(item)
            self.updateTable()
        }
        let cancelAction = UIAlertAction(title: Constants.String.cancelTitle, style: .cancel)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func pressedCheckmark(_ isDone: Bool, on item: Task) {
        self.crudManager.update(item, withKeyValue: ["isDone": isDone])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.String.cellID, for: indexPath) as! TaskTableViewCell
        let task = self.tasks[indexPath.row]
        cell.title = task.name
        cell.isDone = task.isDone
        cell.trashAction = { [weak self] in self?.trashCellPressed(on: task) }
        cell.actions.done = { [weak self] in self?.pressedCheckmark(true, on: task) }
        cell.actions.undone = { [weak self] in self?.pressedCheckmark(false, on: task) }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = self.tasks[indexPath.row]
        self.cellPressed(on: task)
    }
}