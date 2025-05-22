//
//  SegmentControl.swift
//  IMT-iOS
//
//  Created on 14/03/2024.
//
    

import UIKit

protocol SegmentControlDelegate {
    func segmentControl(_ segmentControl: SegmentControl, didSelect item: UIButton)
    
    func segmentControl(_ segmentControl: SegmentControl, shouldSelect item: UIButton) -> Bool
}

class SegmentControl: UIView {
    @IBOutlet private weak var stackView: UIStackView!
    
    var items: [UIButton] = [] {
        didSet {
            bind()
        }
    }
    
    var selectedSegmentIndex: Int = 0 {
        didSet {
            bind()
        }
    }
    
    var numberOfSegment: Int {
        return items.count
    }
    
    var distribution: UIStackView.Distribution {
        set {
            stackView.distribution = newValue
            makeHugingContentSize()
            layoutIfNeeded()
        }
        get {
            stackView.distribution
        }
    }
    
    var delegate: SegmentControlDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = min(frame.size.width / 2.0, frame.size.height / 2.0)
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    @objc func actionClick(_ sender: UIButton) {
        if let delegate = delegate {
            if delegate.segmentControl(self, shouldSelect: sender) && selectedSegmentIndex != sender.tag {
                selectedSegmentIndex = sender.tag
                delegate.segmentControl(self, didSelect: sender)
            }
        } else {
            selectedSegmentIndex = sender.tag
        }
    }
    
    func removeAllSegments() {
        items.removeAll()
        stackView.removeAllSubviews()
    }
    
    func makeHugingContentSize() {
        if distribution != .fillEqually {
            stackView.arrangedSubviews.forEach { view in
                if let button = view as? UIButton, let contentSize = button.titleLabel?.contentSize {
                    button.widthAnchor.constraint(equalToConstant: contentSize.width + 30).isActive = true
                }
            }
        }
    }
    
    private func bind() {
        stackView.removeAllSubviews()
        for item in items {
            let selected = item.tag == selectedSegmentIndex
            item.setTitleColor(selected ? .white : .quickSilver, for: .normal)
            item.backgroundColor = selected ? .main : .white
            item.titleLabel?.font = UIFont.appFontW6Size(16)
            item.addTarget(self, action: #selector(actionClick), for: .touchUpInside)
            stackView.addArrangedSubview(item)
        }
        makeHugingContentSize()
    }
}
