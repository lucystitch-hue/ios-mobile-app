//
//  RaceTBCell.swift
//  IMT-iOS
//
//  Created by dev on 09/03/2023.
//

import UIKit

protocol RaceCellDelegate {
    func didShowResult(atIndex index: Int, link: JMLink)
    func didShowVideo(atIndex index: Int, link: JMLink)
    func didShowDetail(atIndex index: Int, link: JMLink)
}

class RaceCell: UITableViewCell {
    
    @IBOutlet weak var lbNo: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lblClass: UILabel!
    @IBOutlet weak var lbRaceName: UILabel!
    @IBOutlet weak var lbRaceDescription: UILabel!
    @IBOutlet weak var vBackgroundClass: UIView!
    @IBOutlet weak var vRank: UIView!
    @IBOutlet weak var btnOdds: UIButton!
    @IBOutlet weak var vVideo: UIView!
    @IBOutlet weak var vOdds: UIView!
    
    static let identifier = "RaceCell"
    public var delegate: RaceCellDelegate?
    private var index: Int!
    private var race: RaceModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    public func setup(_ race: RaceModel?, atIndex index: Int, rankColor: UIColor?) {
        guard let race = race else { return }
        guard let rankColor = rankColor else { return }
        
        self.race = race
        self.index = index
        lbNo.attributedText = attributeTop(no: race.no)
        lbTime.text = race.starttime.toDate()?.toString(format: IMTDateFormatter.IMTHHColonMM.rawValue)
        btnOdds.setTitle(race.getOddsTitle(), for: .normal)
        vVideo.backgroundColor = race.getBackgroundColorVideo()
        
        let info = race.getNameAndGrade()
        lbRaceName.text = info.name
        vBackgroundClass.isHidden = info.grade == nil
        lblClass.text = info.grade
        vBackgroundClass.backgroundColor = GradeName(rawValue: info.grade ?? "")?.colorRace()
        lbRaceDescription.attributedText = race.descriptionAttribute()
        vOdds.backgroundColor = race.getBackgroundColorOdds()
        self.vRank.backgroundColor = rankColor
    }
    
    //MARK: Action
    @IBAction func actionShowResult(_ sender: Any) {
        var url: String?
        var isPost: Bool = true
        if(race.result == true) {
            url = race.resultUrl
        } else if(race.odds == true) {
            url = race.oddsUrl
        }
        
        guard let url = url else { return }
        let link: JMLink = (url: url, post: isPost)
        self.delegate?.didShowResult(atIndex: index, link: link)
    }
    
    @IBAction func actionShowVideo(_ sender: Any) {
        if(race.video) {
            guard let url = race.videoUrl else { return }
            let link: JMLink = (url: url, post: false)
            self.delegate?.didShowVideo(atIndex: index, link: link)
        }
    }
    
    @IBAction func actionShowDetail(_ sender: Any) {
        guard let linkURL = race.linkUrl else { return }
        let link: JMLink = (url: linkURL, post: true)
        self.delegate?.didShowDetail(atIndex: index, link: link)
    }
    
}

//MARK: Private
extension RaceCell {
    private func attributeTop(no: String) -> NSAttributedString {
        let top = String(Int(no) ?? 0)
        let symbol = "R"
        
        let attrbutes = NSMutableAttributedString()
        let textColor: UIColor = .white
        
        let attrTop = NSAttributedString(string: top, attributes: [NSAttributedString.Key.font: UIFont.appFontNumberBoldSize(27), NSAttributedString.Key.foregroundColor: textColor,  NSAttributedString.Key.kern: 0])
        
        let attrSymbol = NSAttributedString(string: symbol, attributes: [NSAttributedString.Key.font: UIFont.appFontW7Size(17), NSAttributedString.Key.foregroundColor: textColor])
        
        attrbutes.append(attrTop)
        attrbutes.append(attrSymbol)
        
        return attrbutes
    }
}
