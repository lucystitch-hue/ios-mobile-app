//
//  ListQuestionsVC.swift
//  IMT-iOS
//
//  Created by dev on 18/05/2023.
//

import UIKit

class ListQuestionsVC: BaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbAnswerDeadline: UILabel!
    @IBOutlet weak var btnAnswerTheSurvey: UIButton!
    
    private var viewModel: ListQuestionsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func gotoBack() {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionAnswerTheSurvey(_ sender: Any) {
        let link = TransactionLink.answerTheSurvey.rawValue
        self.transitionFromSafari(link)
    }
}

extension ListQuestionsVC {
    private func setupUI() {
        configLabel()
    }
    
    private func setupData() {
        viewModel = ListQuestionsViewModel()

        viewModel.isEnabledBtn.bind { [weak self] result in
            guard let result = result else { return }
            guard let isEnabled = result.data else { return }
            
            self?.btnAnswerTheSurvey.isEnabled = isEnabled
            let colorBtn: UIColor = isEnabled ? .spanishOrange : .americanSilver
            self?.btnAnswerTheSurvey.backgroundColor = colorBtn
            self?.lbAnswerDeadline.isHidden = result.isIntial || isEnabled
        }
    }
    
    private func configLabel(){
        lbTitle.attributedText = self.configAttribute(text: .ListQuestionString.title, alignmentText: "center")
        lbContent.attributedText = self.configAttribute(text: .ListQuestionString.content, alignmentText: "left")
    }

}
