//
//  HitBettingTicketArchiveCell.swift
//  IMT-iOS
//
//  Created by dev on 13/03/2023.
//

import UIKit

protocol IBaseMemorialCell {
    func getDateLabel() -> UILabel
    func getTitleLabel() -> UILabel
    func getGradeLabel() -> UILabel
    func getNameLabel() -> UILabel
    func getBackgroundView() -> UIView
    func getBackgroundGradeView() -> UIView
    func getGroupRadioView() -> UIView
    func getRadioImageView() -> UIImageView
    func getGroupNameStackView() -> UIStackView
    
    func commonInit()
    func config(item: IListQRModel?)
    var onChoice:((_ item: IListQRModel) -> Void) { get set }
}

extension IBaseMemorialCell {
    func commonInit() {
        self.getBackgroundView().cornerRadius(radius: Constants.RadiusConfigure.medium)
        self.getBackgroundView().setShadow()
    }
    
    func config(item: IListQRModel?) {
        guard let item = item else { return }
        
        let grade = GradeName(rawValue: item.grade)
        getDateLabel().text = item.dateToString()
        getTitleLabel().text = "\(item.placeToString())  \(item.raceNoToString())"
        getGradeLabel().text = grade?.toString() ?? item.grade
        getBackgroundGradeView().backgroundColor = grade?.color()
        getGradeLabel().isHidden = getGradeLabel().text?.isEmpty ?? false
        getNameLabel().text = item.name.trimmingCharacters(in: .whitespaces)
        
        let isHiddenGroupName = getGradeLabel().text?.isEmpty ?? false && getNameLabel().text?.isEmpty ?? false
        getGroupNameStackView().isHidden = isHiddenGroupName
    }
}

class IMemorialCell: UITableViewCell {

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
    static let identifier = "IMemorialCell"
    static let space = Utils.scaleWithHeight(19)
    
    //MARK: Public properties
    public var onChoice:((_ item: IListQRModel) -> Void) = {_ in }
    
    //MARK: Private properties
    private var item: IListQRModel!
    private var showRadioButton: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        self.selectionStyle = .none
    }
    
    public func setup(item: IListQRModel?, showRadioButton: Bool = false) {
        guard let item = item else { return }
        self.item = item
        self.showRadioButton = showRadioButton
        config(item: item)
        loadRadio(item.choice, show: showRadioButton)
    }
    
    //MARK: Action
    @IBAction func actionSelected(_ sender: Any) {
        onChoice(item)
        loadRadio(item.choice)
    }
}

//MARK: IBaseMemorialCell
extension IMemorialCell: IBaseMemorialCell {
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

//MARK: Private
extension IMemorialCell {
    private func loadRadio(_ choice: Bool, show: Bool = true) {
        Utils.mainAsync {
            self.imgRadio.image = choice ? .icSelectRadioButton : .icUnselectRadioButton
            self.vRadioGroup.isHidden = !show
        }
    }
}
