//
//  CLVHeaderTitle.swift
//  IMT-iOS
//
//  Created by dev on 23/05/2023.
//

import UIKit

class CLVHeaderTitle: UICollectionReusableView {
    
    static let identifier = "CLVHeaderTitle"
    
    private var lblSubTitle = UILabel()
    private var stContent: UIStackView = UIStackView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private var space: Float = 10
    
    public func setup(subTitle: String? = nil, space: Float = 10) {
        self.space = space
        self.lblSubTitle.text = subTitle
    }
    
    public func getContentHeight() -> CGFloat {
        let paddingHorizotal = 0.0
        let maxWidth = UIScreen.main.bounds.size.width - paddingHorizotal
        let height = self.lblSubTitle.getSize(constrainedWidth: maxWidth).height + CGFloat(space * 2.0)
        return height
    }
    
    private func setupUI() {
        configStack()
        configSubTitle()
    }
    
    private func configStack() {
        self.addSubview(stContent)
        stContent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stContent.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stContent.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stContent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
        
        stContent.distribution = .fill
        stContent.alignment = .leading
        stContent.axis = .vertical
        
        let vSpaceTop = getSpaceView()
        let vSpaceBottom = getSpaceView()
        
        stContent.addArrangedSubview(vSpaceTop)
        stContent.addArrangedSubview(lblSubTitle)
        stContent.addArrangedSubview(vSpaceBottom)
        
        lblSubTitle.leadingAnchor.constraint(equalTo: stContent.leadingAnchor, constant: 24).isActive = true
    }
    
    private func getSpaceView() -> UIView {
        let vSpace = UIView()
        vSpace.translatesAutoresizingMaskIntoConstraints = false
        vSpace.heightAnchor.constraint(equalToConstant: CGFloat(space)).isActive = true
        
        return vSpace
    }
    
    private func configSubTitle() {
        self.lblSubTitle.font = .appFontW3Size(13)
        self.lblSubTitle.textColor = .lightGray
    }
}
