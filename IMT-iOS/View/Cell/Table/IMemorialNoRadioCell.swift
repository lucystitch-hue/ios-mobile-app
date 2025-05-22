//
//  HitBettingTicketArchiveCell.swift
//  IMT-iOS
//
//  Created by dev on 13/03/2023.
//

import UIKit

class IMemorialNoRadioCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var vBackgroundGrade: UIView!
    @IBOutlet weak var vRadioGroup: UIView!
    @IBOutlet weak var imgRadio: UIImageView!
    @IBOutlet weak var svGroupName: UIStackView!
    
    //MARK: Static properties
    static let identifier = "IMemorialNoRadioCell"
    static let space = Utils.scaleWithHeight(19)
    
    //MARK: Public properties
    public var onChoice:((_ item: IListQRModel) -> Void) = {_ in }
    
    //MARK: Private properties
    private var item: IListQRModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        self.selectionStyle = .none
    }
    
    public func setup(item: IListQRModel?) {
        guard let item = item else { return }
        self.item = item
        config(item: item)
    }
    
    //MARK: Action
    @IBAction func actionSelected(_ sender: Any) {
        onChoice(item)
    }
}

//MARK: IBaseMemorialCell
extension IMemorialNoRadioCell: IBaseMemorialCell {
    func getDateLabel() -> UILabel {
        return lblDate
    }
    
    func getTitleLabel() -> UILabel {
        return lblTitle
    }
    
    func getGradeLabel() -> UILabel {
        return lblGrade
    }
    
    func getNameLabel() -> UILabel {
        return lblName
    }
    
    func getBackgroundView() -> UIView {
        return vBackground
    }
    
    func getBackgroundGradeView() -> UIView {
        return vBackgroundGrade
    }
    
    func getGroupRadioView() -> UIView {
        return vRadioGroup
    }
    
    func getRadioImageView() -> UIImageView {
        return imgRadio
    }
    
    func getGroupNameStackView() -> UIStackView {
        return svGroupName
    }
}
