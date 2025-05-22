//
//  IMTRadioButtonCell.swift
//  IMT-iOS
//
//  Created on 24/01/2024.
//
    

import UIKit

class IMTRadioButtonCell: UITableViewCell {
    
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var imgRadioButton: UIImageView!
    
    static let identifier = "IMTRadioButtonCell"
    static let space = Utils.scaleWithHeight(10)
    
    var onChecked:((IndexPath) -> Void)!
    
    var checked: Bool = false {
        didSet {
            imgRadioButton.image = checked ? .icRadioButtonSelected : .icRadioButtonUnselected
            lbTitle.textColor = checked ? .dartCharcocal3 : .darkCharcoal
            lbTitle.font = checked ? .appFontW7Size(17) : .appFontW6Size(17)
        }
    }

    private var indexPath: IndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    public func setup(item: PreferredDisplayType?, indexAt indexPath: IndexPath, selected: Bool = false) {
        guard let item = item else { return }
        self.indexPath = indexPath
        checked = selected
        lbTitle.text = item.description()
    }
    
    @IBAction func actionSelected(_ sender: Any) {
        onChecked(indexPath)
    }
    
}
