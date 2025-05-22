//
//  IMTPasswordTextField.swift
//  IMT-iOS
//
//  Created on 11/04/2024.
//


import UIKit

class IMTPasswordTextField: IMTTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        enablePasswordToggle()
    }
    
    private func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(.icEyeInvisible, for: .normal)
        } else {
            button.setImage(.icEyeVisible, for: .normal)
        }
    }
    
    private func enablePasswordToggle(){
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    
    @IBAction func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry.toggle()
        
        if let existingText = text, isSecureTextEntry {
            text?.removeAll()
            insertText(existingText)
        }
        
        setPasswordToggleImage(sender as! UIButton)
    }
}
