//
//  WarningView.swift
//  IMT-iOS
//
//  Created by dev on 05/06/2023.
//

import Foundation
import UIKit

protocol WarningViewDelegate {
    func didHeightChange(_ height: Float, view: WarningView)
}

class WarningView: UIView {
    
    @IBOutlet private var vContent: UIView!
    @IBOutlet private weak var vHeader: UIView!
    @IBOutlet private weak var vFooter: UIView!
    @IBOutlet private weak var svContainer: UIStackView!
    @IBOutlet private weak var lblCaption: IMTLabel!
    @IBOutlet private weak var svContent: UIStackView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblContent: UILabel!
    @IBOutlet private weak var cstHeightHeader: NSLayoutConstraint!
    @IBOutlet private weak var cstHeightFooter: NSLayoutConstraint!
    
    private var spaceContainer: CGFloat {
        get {
            return svContainer.spacing
        }
        
        set {
            svContainer.spacing = newValue
        }
    }
    
    private var spaceContent: CGFloat {
        get {
            return svContent.spacing
        }
        
        set {
            self.svContent.spacing = newValue
        }
    }
    
    private var heighHeader: CGFloat {
        get {
            return cstHeightHeader.constant
        }
        
        set {
            self.cstHeightHeader.constant = newValue
        }
    }
    
    private var heightFooter: CGFloat {
        get {
            return cstHeightFooter.constant
        }
        
        set {
            self.cstHeightFooter.constant = newValue
        }
    }
    
    private var radius: CGFloat = 12 {
    didSet {
        setRadius(radius)
    }
}
    
    //MARK: Public
    public var delegate: WarningViewDelegate?
    
    public var configuaration: WarningViewConfiguration! {
        didSet {
            builder(configuaration)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateHeightView()
        setRadius(radius)
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public func setup(configuration: WarningViewConfiguration) {
        self.configuaration = configuration
        updateHeightView()
    }
    
}

//MARK: Private
extension WarningView {
    
    private func commonInit() {
        configContent()
    }
    
    private func configContent() {
        Bundle.main.loadNibNamed("WarningView", owner: self, options: nil)
        self.addSubview(vContent)
        Utils.constraintFull(parent: self, child: vContent)
    }
    
    private func updateHeightView() {
        let hTitle = lblTitle.getSize(constrainedWidth: self.lblTitle.frame.width).height + 10
        let hContent = lblContent.getSize(constrainedWidth: self.lblContent.frame.width).height + 10
        
        let height = heighHeader + spaceContainer + hTitle + spaceContent + hContent + heightFooter + 10
        
        self.delegate?.didHeightChange(Float(height), view: self)
        self.lblTitle.heightConstraint?.constant = CGFloat(hTitle - 10 + 4)
    }
    
    private func setRadius(_ radius: CGFloat) {
        self.cornerRadius(radius: radius)
        vContent.cornerRadius(radius: radius)
        vHeader.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: radius)
        svContent.roundCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: radius)
        vFooter.roundCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: radius)
    }
    
    private func builder(_ configuration: WarningViewConfiguration) {
        if let heightHeader = configuration.heightHeader {
            self.heighHeader = heightHeader
        }
        
        if let heightFooter = configuration.heightFooter {
            self.heightFooter = heightFooter
        }
        
        if let spaceContent = configuration.spaceContent {
            self.spaceContent = spaceContent
        }
        
        if let spaceContainer = configuration.spaceContainer {
            self.spaceContainer = spaceContainer
        }
        
        //TODO: Caption
        if let captionColor = configuration.captionColor {
            self.lblCaption.textColor = captionColor
        }
        
        if let captionBgColor = configuration.captionBgColor {
            self.vHeader.backgroundColor = captionBgColor
        }
        
        self.lblCaption.text = configuration.caption
        
        //TODO: Title
        if let titleColor = configuration.titleColor {
            self.lblTitle.textColor = titleColor
        }
        
        if let titleFont = configuration.titleFont {
            self.lblTitle.font = titleFont
        }
        
        self.lblTitle.text = configuration.title
        
        //TODO: Content
        if let contentColor = configuration.contentColor {
            self.lblContent.textColor = contentColor
        }
        
        if let contentFont = configuration.contentFont {
            self.lblContent.font = contentFont
        }
        
        self.lblContent.text = configuration.content
        
    }
}
