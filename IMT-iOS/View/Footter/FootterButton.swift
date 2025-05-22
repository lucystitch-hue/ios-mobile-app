//
//  FootterButton.swift
//  IMT-iOS
//
//  Created by dev on 24/07/2023.
//

import UIKit

class FootterButton: UIView {
    @IBOutlet var vContent: UIView!
    @IBOutlet weak var btnAction: IMTButton!
    @IBOutlet weak var cstLeftButton: NSLayoutConstraint!
    
    public var onAction: JVoid?
    
    public var paddingLeft: CGFloat {
        get {
            return self.cstLeftButton.constant
        }
        
        set {
            self.cstLeftButton.constant = newValue
        }
    }
    
    public var title: String {
        get {
            return self.btnAction.titleLabel?.text ?? ""
        }
    
        set {
            self.btnAction.titleLabel?.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        commontInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commontInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    //MARK: Action
    @IBAction func actionButton(_ sender: Any) {
        onAction?()
    }
}

//MARK: Private
extension FootterButton {
    private func commontInit() {
        Bundle.main.loadNibNamed("FootterButton", owner: self)
        self.addSubview(self.vContent)
        Utils.constraintFull(parent: self, child: vContent)
        
    }
}
