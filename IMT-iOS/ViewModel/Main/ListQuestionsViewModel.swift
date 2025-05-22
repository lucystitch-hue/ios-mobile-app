//
//  ListQuestionsViewModel.swift
//  IMT-iOS
//
//  Created by dev on 18/05/2023.
//

import Foundation
import UIKit

protocol ListQuestionsViewModelProtocol {
    var isEnabledBtn: ObservableObject<(data: Bool?, isIntial: Bool)> {get set}
    
    func configAttribute( text: String, alignmentText: String)->NSAttributedString?
}

class ListQuestionsViewModel: BaseViewModel {
    var isEnabledBtn: ObservableObject<(data: Bool?, isIntial: Bool)> = ObservableObject<(data: Bool?, isIntial: Bool)>((false, true))
    
    override init() {
        super.init()
        
        sysEnv()
    }
}

extension ListQuestionsViewModel: ListQuestionsViewModelProtocol {
    
    func configAttribute( text: String, alignmentText: String)->NSAttributedString? {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        
        if(alignmentText == "center"){
            paragraphStyle.alignment =  .center
        } else if (alignmentText == "left" ){
            paragraphStyle.alignment =  .left
        }
        
        paragraphStyle.lineSpacing = 7
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        return attributedString
    }

}

extension ListQuestionsViewModel{
    private func sysEnv(){
        manager.call(endpoint: .sysEnv, showLoading: true, completion: responseSysEnv)
    }
    
    private func responseSysEnv(_ response: ResponseSysEnv?, success: Bool) {
        self.isEnabledBtn.value = (response?.configuringSurveyQuestionList(), false)
    }
}
