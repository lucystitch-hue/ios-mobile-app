//
//  SubNumerLinksCell.swift
//  IMT-iOS
//
//  Created by dev on 21/03/2023.
//

import UIKit

class SubNumerLinksCell: UITableViewCell {
    
    @IBOutlet weak var lbsubscriberNumber: IMTLabel!
    @IBOutlet weak var lbpars: IMTLabel!
    @IBOutlet weak var lbpin: IMTLabel!
    @IBOutlet weak var btnPriority: IMTButton!
  
    @IBOutlet weak var vContent: IMTView!
    
    static let identifier: String = "SubNumerLinksCell"
    static let heightFooter: Float = Float(Utils.scaleWithHeight(10))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        configContentView()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func configContentView(){
        NSLayoutConstraint.activate([
            vContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            vContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            vContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            vContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    

    public func setup(_ subNumerLinks: SubNumerLinksModel?) {
        guard let subNumerLink = subNumerLinks else { return }

        self.btnPriority.setTitle(subNumerLink.titleBtn, for: .normal)
        let colorBackgroundBtn: UIColor = subNumerLink.isPriority ? .main : .white
        self.btnPriority.backgroundColor = colorBackgroundBtn
        let colorTitleBtn: UIColor = subNumerLink.isPriority ? .white : .quickSilver
        self.btnPriority.setTitleColor(colorTitleBtn, for: .normal)
        self.lbsubscriberNumber.text = subNumerLink.subscriberNumber
        self.lbpars.text = subNumerLink.pars
        self.lbpin.text = subNumerLink.pin
    }
    
}
