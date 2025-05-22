//
//  IMTHeaderView.swift
//  IMT-iOS
//
//  Created by dev on 07/06/2023.
//

import Foundation
import UIKit

class IMTHeaderView: UIView {
    
    @IBOutlet private var vContent: UIView!
    @IBOutlet private weak var vContainer: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var btnBack: UIButton!
    @IBOutlet weak var imvLogo: UIImageView!
    
    public var title: String{
        get {
            return lblTitle.text ?? ""
        }
        
        set {
            self.lblTitle.text = newValue
        }
    }
    public var theme: UIColor {
        get {
            return self.vContainer.backgroundColor ?? .white
        }
        
        set {
            self.vContainer.backgroundColor = newValue
        }
    }
    public var tint: UIColor {
        get {
            return self.lblTitle.textColor
        }
        
        set {
            self.lblTitle.textColor = newValue
            self.btnBack.tintColor = newValue
        }
    }
    public var hiddenBack: Bool {
        get {
            return self.btnBack.isHidden
        }
        
        set {
            self.btnBack.isHidden = newValue
        }
    }
    public var hiddenLogo: Bool {
        get {
            return self.imvLogo.isHidden
        }
        
        set {
            self.imvLogo.isHidden = newValue
        }
    }
    
    var onBack: JVoid?
    
    //MARK: Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: Action
    @IBAction private func actionBack(_ sender: Any) {
        onBack?()
    }
}

//MARK: Public
extension IMTHeaderView {
    
}

//MARK: Private
extension IMTHeaderView {
    private func commonInit() {
        self.configUI()
        self.configData()
    }
    
    private func configUI() {
        configContentView()
        configButton()
    }
    
    private func configData() {
        
    }
   
    private func configContentView() {
        Bundle.main.loadNibNamed("IMTHeaderView", owner: self, options: nil)
        self.addSubview(vContent)
        
        Utils.constraintFull(parent: self, child: vContent)
    }
    
    private func configButton() {
        let image = self.btnBack.imageView?.image?.resizedImage(CGSize(width: 56, height: 32))
        btnBack.setImage(image, for: .normal)
    }
}
