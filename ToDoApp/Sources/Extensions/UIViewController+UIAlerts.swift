//
//  UIViewController+UIAlerts.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 20.09.2022.
//

import UIKit

extension UIViewController {
    private enum Constants {
        enum String {
            static let cancelTitle = "Common.cancelTitle".localized
            static let okTitle = "Common.okTitle".localized
        }
    }
    
    func showAlertWithTextfield(title: String, 
                                placeholder: String? = nil, 
                                completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, 
                                      message: nil, 
                                      preferredStyle: .alert)
        alert.addTextField()
        guard let textField = alert.textFields?.first else { return }
        textField.text = placeholder ?? ""
        
        let doneAction = UIAlertAction(title: Constants.String.okTitle, style: .default) { _ in
            guard let text = textField.text,
                  !text.isEmpty else { return }
            textField.text = placeholder ?? ""
            completion(text)
        }
        let cancelAction = UIAlertAction(title: Constants.String.cancelTitle, style: .cancel)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func showAlertWithSheetOfActions<T: ObjectWithName>(title: String, 
                                                        objects: [T], 
                                                        completion: @escaping (T) -> Void) {
        let alert = UIAlertController(title: title, 
                                      message: nil, 
                                      preferredStyle: .actionSheet)
        objects.forEach { object in
            let alertAction = UIAlertAction(title: object.name, style: .default) { _ in
                completion(object)
            }
            alert.addAction(alertAction)
        }
        let cancelAction = UIAlertAction(title: Constants.String.cancelTitle, style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func showAlertWithActionsAndCancelAction(title: String, actions: [Action]) {
        let alert = UIAlertController(title: title, 
                                      message: nil, 
                                      preferredStyle: .alert)
        actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: .default) { _ in
                action.action()
            }
            alert.addAction(alertAction)
        }
        let cancelAction = UIAlertAction(title: Constants.String.cancelTitle, style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func showDisclaimerAlert(title: String) {
        let alert = UIAlertController(title: title, 
                                      message: nil, 
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.String.okTitle, style: .cancel)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
