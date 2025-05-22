//
//  IMTHeaderBar.swift
//  IMT-iOS
//
//  Created by dev on 02/08/2023.
//

import Foundation
import UIKit

class IMTHeaderBar: UIView {
    
    @IBOutlet private var vContent: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet weak var lbTitleSub: UILabel!
    @IBOutlet weak var vSpaceTop: UIView!
    @IBOutlet weak var vSpaceBottom: UIView!
    
    public var title: String{
        get {
            return lblTitle.text ?? ""
        }
        
        set {
            self.lblTitle.text = newValue
        }
    }
    public var titleSub: String{
        get {
            return lbTitleSub.text ?? ""
        }
        
        set {
            self.lbTitleSub.text = newValue
            configTitleSub()
        }
    }
    public var theme: UIColor {
        get {
            return self.vContent.backgroundColor ?? .white
        }
        
        set {
            self.vContent.backgroundColor = newValue
        }
    }
    public var tint: UIColor {
        get {
            return self.lblTitle.textColor
        }
        
        set {
            self.lblTitle.textColor = newValue
        }
    }
    
    //MARK: Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

//MARK: Public
extension IMTHeaderBar {
    
}

//MARK: Private
extension IMTHeaderBar {
    private func commonInit() {
        self.configUI()
        self.configData()
    }
    
    private func configUI() {
        configContentView()
        configTitleSub()
    }
    
    private func configData() {
        
    }
   
    private func configContentView() {
        Bundle.main.loadNibNamed("IMTHeaderBar", owner: self, options: nil)
        self.addSubview(vContent)
        
        Utils.constraintFull(parent: self, child: vContent)
    }
    
    private func configTitleSub() {
        if(titleSub.isEmpty) {
            lbTitleSub.isHidden = true
            vSpaceTop.isHidden = true
            vSpaceBottom.isHidden = true
        }
    }
}
