//
//  ClickableHeaderView.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 20.09.2022.
//

import UIKit

final class ClickableHeaderView: UIView {
    typealias Closure = () -> Void
    
    private var title: String
    private var action: Closure?
    
    init(title: String, action: Closure? = nil) {
        self.title = title
        self.action = action
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupView() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.title
        self.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewPressed(_:)))
        self.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        ])
    }
    
    @objc
    private func viewPressed(_ sender: UITapGestureRecognizer) {
        self.action?()
    }
}
