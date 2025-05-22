//
//  InputStepRegisterCell.swift
//  IMT-iOS
//
//  Created by dev on 15/03/2023.
//

import UIKit

class IMTCheckboxCell: UITableViewCell {

    @IBOutlet weak var imvCheck: UIImageView!
    @IBOutlet weak var lblLabel: UILabel!
    @IBOutlet weak var cstHeightSpace: NSLayoutConstraint!
    
    var onChecked:((IndexPath) -> Void)!
    var checked: Bool!
    
    static let identifier = "IMTCheckboxCell"
    static let space = Utils.scaleWithHeight(5.0)
    
    private var index: Int!
    private var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    public func setup(item: InputStepRegisterModel?, indexAt indexPath: IndexPath) {
        guard let item = item else { return }
        self.indexPath = indexPath
        checked = item.selected
        lblLabel.text = item.title
        cstHeightSpace.constant = 0
        
        self.updateControl(checked)
    }
    
    public func setup(item: IReasonDelete?, indexAt indexPath: IndexPath) {
        guard let item = item else { return }
        self.indexPath = indexPath
        self.checked = item.checked
        lblLabel.text = item.title
        cstHeightSpace.constant = 10
        
        self.updateControl(checked)
    }
    
    @IBAction func actionCheck(_ sender: Any) {
        self.onChecked(indexPath)
    }
    
}

//MARK: Private
extension IMTCheckboxCell {
    private func updateControl(_ checked: Bool) {
        imvCheck.image = checked ? .icCheckboxBoldSelected : .icCheckboxBoldUnSelected
        lblLabel.textColor = checked ? .dartCharcocal3 : .darkCharcoal
        lblLabel.font = checked ? .appFontW7Size(14) : .appFontW6Size(14)
    }
}
