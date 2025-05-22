//
//  BadgeView.swift
//  IMT-iOS
//
//  Created on 15/03/2024.
//
    

import UIKit

class BadgeView: UIView {
    private(set) lazy var textLabel: UILabel = setupLabel()
    var textInsets: UIEdgeInsets = .zero {
        didSet { setupConstraints() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = min(frame.size.width / 2.0, frame.size.height / 2.0)
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func makeEmpty() {
        textLabel.textColor = .clear
        backgroundColor = .clear
    }
    
    private func initialSetup() {
        widthAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
        setupConstraints()
    }
    
    private func setupConstraints() {
        constraints.forEach { constraint in
            if let secondItem = constraint.secondItem as? UILabel, secondItem == textLabel {
                removeConstraint(constraint)
            }
        }
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: textLabel.leftAnchor, constant: -textInsets.left),
            rightAnchor.constraint(equalTo: textLabel.rightAnchor, constant: textInsets.right),
            topAnchor.constraint(equalTo: textLabel.topAnchor, constant: -textInsets.top),
            bottomAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: textInsets.bottom)
        ])
        updateConstraints()
    }
    
    private func setupLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        addSubview(label)
        return label
    }
}
