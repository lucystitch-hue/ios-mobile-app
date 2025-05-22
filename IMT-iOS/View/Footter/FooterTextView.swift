//
//  FooterTextField.swift
//  IMT-iOS
//
//  Created by dev on 08/05/2023.
//

import Foundation
import UIKit

class FooterTextView: UIView {
    @IBOutlet var vContent: UIView!
    @IBOutlet weak var tvTitle: UITextView!
    @IBOutlet weak var vBorderTextField: UIView!
    @IBOutlet weak var cstHeightSpace: NSLayoutConstraint!
    
    let maxLength = 250
    
    public var space: CGFloat {
        get {
            return self.cstHeightSpace.constant
        }
        
        set {
            self.cstHeightSpace.constant = newValue
        }
    }
    
    public var characterLimitEnabled: Bool = true {
        didSet {
            updateCharacterLimitStatus()
        }
    }
    
    public var onTextChange: JString?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        commontInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        commontInit()
        tvTitle.text = text
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configBorderTextField()
    }
}

//MARK: Private
extension FooterTextView {
    private func commontInit() {
        Bundle.main.loadNibNamed("FooterTextView", owner: self)
        self.addSubview(self.vContent)
        Utils.constraintFull(parent: self, child: vContent)
    }
    
    private func configBorderTextField() {
        vBorderTextField.layer.borderColor = UIColor.lightGray.cgColor
        vBorderTextField.layer.borderWidth = 1.0
        vBorderTextField.manualRadius = 10
    }
    
    private func updateCharacterLimitStatus() {
          if characterLimitEnabled {
              tvTitle.delegate = self
          } else {
              tvTitle.delegate = nil
          }
      }
}

extension FooterTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard characterLimitEnabled else {
            return true
        }
        
        let currentString = (textView.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: text)

        onTextChange?(newString)
        
        return newString.count <= maxLength
    }
}
