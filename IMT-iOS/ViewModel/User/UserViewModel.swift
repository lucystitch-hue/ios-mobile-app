//
//  UserViewModel.swift
//  IMT-iOS
//
//  Created by dev on 10/03/2023.
//

import Foundation
class UserViewModel: BaseViewModel {
    
    var confirmUser: ObservableObject<[ConfirmUserInforModel]> = ObservableObject<[ConfirmUserInforModel]>([])
   
    
    override init() {
        super.init()
        confirmUser.value = hardcodeConfirmUser()
        
    }
}

//MARK: Hardcode
extension UserViewModel {

    func hardcodeConfirmUser() -> [ConfirmUserInforModel]{
        return [
            ConfirmUserInforModel(firstLastName: "〇〇 〇〇", seimei: "〇〇 〇〇", dateBirth:"****年**月**日" , mail: "****@****.com", postCode: "000-0000", sex: "女性", profession: "〇〇", horseRacingYear: "****年", servicesUse: "〇〇", triggerRegistration: "〇〇", holidaysInterested: "〇〇"),
        ]
        
       
    }
}


