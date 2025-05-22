//
//  FormVotingOnline.swift
//  IMT-iOS
//
//  Created by dev on 15/06/2023.
//

import Foundation

class FormVotingOnline: FormData {
    var onFilled: JBool?
    
    var type: VotingOnlineType!
    var iPatId: String?
    var iPatPars: String?
    var iPatPass: String?
    var ysnFlg: String?
    
    static let maxLengthIPatId: Int = 8
    static let maxLengthIPars: Int = 4
    static let maxLengthIPatPass: Int = 4
    
    init(type: VotingOnlineType, intitalFromUserManager: Bool = false) {
        self.type = type
        
        if(intitalFromUserManager) {
            guard let user = UserManager.share().user else { return }
            switch self.type {
            case .ipatOne:
                iPatId = user.iPatId1?.decrypt()
                iPatPars = user.iPatPars1?.decrypt()
                iPatPass = user.iPatPass1?.decrypt()
                ysnFlg = user.ysnFlg1
                break
            case .ipatTwo:
                iPatId = user.iPatId2?.decrypt()
                iPatPars = user.iPatPars2?.decrypt()
                iPatPass = user.iPatPass2?.decrypt()
                ysnFlg = user.ysnFlg2
                break
            case .none:
                break
            }
        } else {
            ysnFlg = getYsnFlg()
        }
    }
    
    func toParam() -> [String : Any] {
        guard let iPatId = iPatId,
              let iPatPars = iPatPars,
              let iPatPass = iPatPass,
              let ysnFlg = ysnFlg
        else { return [:] }

        switch type {
        case .ipatOne:
            return ["iPatId1": iPatId.encrypt(),
                    "iPatPars1": iPatPars.encrypt(),
                    "iPatPass1": iPatPass.encrypt(),
                    "ysnFlg1": ysnFlg]
        case .ipatTwo:
            return ["iPatId2": iPatId.encrypt(),
                    "iPatPars2": iPatPars.encrypt(),
                    "iPatPass2": iPatPass.encrypt(),
                    "ysnFlg2": ysnFlg]
        case .none:
            return [:]
        }
    }
    
    func clearData() {
        iPatId = ""
        iPatPars = ""
        iPatPass = ""
        ysnFlg = "0"
    }
    
    func validate() -> JValidate {
        var message: IMTErrorMessage?

        if(iPatId == nil || iPatPass == nil || iPatPars == nil || iPatId?.count == 0 || iPatPass?.count == 0 ||   iPatPars?.count == 0) {
            message = .emptyNumber
        } else if (validateIPatId() && validateIPatPass() && validateIPatPars()) {
            message = nil
        } else {
            message = .missingNumber
        }
        
        if let message = message {
            return (message, false)
        }
        
        return (nil, true)
        
        /*------------------------------------------------------------------------------------------------------------*/
        func validateIPatId() -> Bool {
            let validLength = iPatId?.count == FormVotingOnline.maxLengthIPatId
            let validCharacter = iPatId?.isASCII ?? false && iPatId?.isNumbers ?? false
            return validLength && validCharacter
        }
        
        func validateIPatPass() -> Bool {
            let validLength = iPatPass?.count == FormVotingOnline.maxLengthIPatPass
            let validCharacter = iPatPass?.isASCII ?? false && iPatPass?.isNumbers ?? false
            return validLength && validCharacter
        }
        
        func validateIPatPars() -> Bool {
            let validLength = iPatPars?.count == FormVotingOnline.maxLengthIPars
            let validCharacter = iPatPars?.isASCII ?? false && iPatPars?.isNumbers ?? false
            return validLength && validCharacter
        }
        /*------------------------------------------------------------------------------------------------------------*/
    }
}

//MARK: Private
extension FormVotingOnline {
    func getYsnFlg() -> String {
        switch type {
        case .ipatOne:
            if let ipatId1 = UserManager.share().user?.iPatId1?.decrypt(), !ipatId1.isEmpty,
                let ysnFlg = UserManager.share().user?.ysnFlg1 {
                return ysnFlg
            } else {
                return UserManager.share().getCurrentIpatSkipLogin() == nil ? "1" : "0"
            }
        case.ipatTwo:
            if let ipatId2 = UserManager.share().user?.iPatId2?.decrypt(), !ipatId2.isEmpty,
                let ysnFlg = UserManager.share().user?.ysnFlg2 {
                return ysnFlg
            } else {
                return UserManager.share().getCurrentIpatSkipLogin() == nil ? "1" : "0"
            }
        case .none:
            return "0"
        }
    }
}
