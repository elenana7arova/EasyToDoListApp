//
//  TaskTableViewCell.swift
//  ToDoApp
//
//  Created by Elena Nazarova on 12.09.2022.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    // MARK: - Internal properties
    
    typealias Closure = (() -> Void)
    
    var trashAction: Closure?
    var actions: (done: Closure?, undone: Closure?)
    var isDone: Bool = false {
        willSet {
            self.checkmarkButton?.setImage(newValue ? Constants.Image.doneImage : Constants.Image.undoneImage, for: .normal)
        }
    }
    var title: String? {
        get { self.titleLabel?.text }
        set { self.titleLabel?.text = newValue }
    }
    
    // MARK: - Private properties
    
    private var titleLabel: UILabel?
    private var trashButton: UIButton?
    private var checkmarkButton: UIButton?
    private enum Constants {
        enum Image {
            static let doneImage = UIImage(systemName: "checkmark.circle.fill")!
            static let undoneImage = UIImage(systemName: "checkmark.circle")!
            static let trashImage = UIImage(systemName: "trash")!
        }
        enum Geometry {
            static let titleLabelLeading: CGFloat = 30
            static let titleLabelWidth: CGFloat = 200
            static let titleLabelVertical: CGFloat = 5
            static let checkmarkButtonWidthAndHeight: CGFloat = 20
            static let trashButtonWidthAndHeight: CGFloat = 20
        }
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupCell() {
        let marginGuide = self.contentView.layoutMarginsGuide
        
        let checkmarkButton = UIButton()
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        checkmarkButton.setImage(self.isDone ? Constants.Image.doneImage : Constants.Image.undoneImage, for: .normal)
        checkmarkButton.addTarget(self, action: #selector(self.checkmarkButtonPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(checkmarkButton)
        self.checkmarkButton = checkmarkButton
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let trashButton = UIButton()
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        trashButton.setImage(Constants.Image.trashImage, for: .normal)
        trashButton.addTarget(self, action: #selector(self.trashButtonPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(trashButton)
        self.trashButton = trashButton
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: Constants.Geometry.titleLabelLeading),
            titleLabel.widthAnchor.constraint(equalToConstant: Constants.Geometry.titleLabelWidth),
            titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: Constants.Geometry.titleLabelVertical),
            titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -Constants.Geometry.titleLabelVertical),
            
            checkmarkButton.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            checkmarkButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            checkmarkButton.heightAnchor.constraint(equalToConstant: Constants.Geometry.checkmarkButtonWidthAndHeight),
            checkmarkButton.widthAnchor.constraint(equalToConstant: Constants.Geometry.checkmarkButtonWidthAndHeight),
            
            trashButton.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            trashButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            trashButton.heightAnchor.constraint(equalToConstant: Constants.Geometry.trashButtonWidthAndHeight),
            trashButton.widthAnchor.constraint(equalToConstant: Constants.Geometry.trashButtonWidthAndHeight)
        ])
    }
    
    @objc
    private func trashButtonPressed(_ sender: UIButton) {
        self.trashAction?()
    }
    
    @objc
    private func checkmarkButtonPressed(_ sender: UIButton) {
        self.isDone.toggle()
        self.isDone ? actions.done?() : actions.undone?()
    }
}
