//
//  HeaderTitle.swift
//  IMT-iOS
//
//  Created by dev on 05/05/2023.
//

import UIKit

class HeaderTitle: UIView {
    
    @IBOutlet var vContent: UIView!
    @IBOutlet weak var svTitle: UIStackView!
    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cstHeightSpace: NSLayoutConstraint!
    @IBOutlet weak var cstLeadingIndex: NSLayoutConstraint!
    @IBOutlet weak var cstTrailingIndex: NSLayoutConstraint!
    
    private var index: String? {
        get {
            return lblIndex.text
        }
        
        set {
            self.lblIndex.isHidden = newValue == nil || newValue!.isEmpty
            self.lblIndex.text = newValue
        }
    }
    private var title: String? {
        get {
            return lblTitle.text
        }
        
        set {
            self.lblTitle.text = newValue
        }
    }
    
    public var space: CGFloat {
        get {
            Utils.scaleWithHeight(self.cstHeightSpace.constant)
        }
        
        set {
            self.cstHeightSpace.constant = newValue
        }
    }
    public var leading: CGFloat {
        get {
            return Utils.scaleWithHeight(self.cstLeadingIndex.constant)
        }
        
        set {
            self.cstLeadingIndex.constant = Utils.scaleWithHeight(newValue)
        }
    }
    public var trailing: CGFloat {
        get {
            return Utils.scaleWithHeight(self.cstTrailingIndex.constant)
        }
        
        set {
            self.cstTrailingIndex.constant = Utils.scaleWithHeight(newValue)
        }
    }
    public var fontTitle: UIFont? {
        get {
            return lblTitle.font
        }
        
        set {
            lblTitle.font = newValue
        }
    }
    public var alignment: UIStackView.Alignment {
        get {
            return self.svTitle.alignment
        }
        
        set {
            self.svTitle.alignment = newValue
        }
    }
    
    public var textColor: UIColor {
        get {
            return lblTitle.textColor
        }
        set {
            lblTitle.textColor = newValue
        }
    }
    
    init(index: String, title: String) {
        super.init(frame: .zero)
        
        commontInit()
        
        self.index = index
        self.title = title
    }
    
    init(title: String) {
        super.init(frame: .zero)
        commontInit()
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        vContent.backgroundColor = backgroundColor
    }
    
}

//MARK: Private
extension HeaderTitle {
    private func commontInit() {
        Bundle.main.loadNibNamed("HeaderTitle", owner: self)
        self.addSubview(self.vContent)
        Utils.constraintFull(parent: self, child: vContent)
    }
}
