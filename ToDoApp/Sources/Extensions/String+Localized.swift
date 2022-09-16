//
//  String+Localized.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 16.09.2022.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
