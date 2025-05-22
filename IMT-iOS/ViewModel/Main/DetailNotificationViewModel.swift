//
//  DetailNotificationViewModel.swift
//  IMT-iOS
//
//  Created by dev on 20/06/2023.
//

import Foundation
import UIKit

protocol DetailNotificationViewModelProtocol {
    var detailDataModel: ObservableObject<[DetailNotificationModel]> { get set }
    
    func getMessageAttribute() -> NSAttributedString?
    func callAPI()
}

class DetailNotificationViewModel:BaseViewModel {
    var detailDataModel: ObservableObject<[DetailNotificationModel]> = ObservableObject<[DetailNotificationModel]>([])
    private var bundle: [NotificationBundleKey: Any]?
    private var firstLoad = true
    
    init(bundle: [NotificationBundleKey: Any]?) {
        super.init()
        self.bundle = bundle
    }
}

//MARK: Private
extension DetailNotificationViewModel {
    private func getDetailData() -> NotificationModel? {
        guard let data = bundle?[.detail] as? NotificationModel else { return nil }
        return data
    }
    
    func callAPI() {
        if let detail = self.detailDataModel.value, detail.isEmpty {
            if(firstLoad) {
                self.detail()
            } else {
                Utils.showProgress()
                Utils.mainAsyncAfter {
                    self.detail()
                }
            }
            
            self.firstLoad = false
        }
    }
}

extension DetailNotificationViewModel: DetailNotificationViewModelProtocol {
    func getMessageAttribute() -> NSAttributedString? {
        guard let detail = detailDataModel.value?.first else { return nil }
        guard let message = detail.message else { return nil }
        
        if let url = detail.url {
            return NSAttributedString.makeHyperlink(text: message, url: url)
        } else {
            return NSAttributedString(string: message, attributes: [NSAttributedString.Key.font: UIFont.appFontW4Size(16)])
        }
    }
}

//MARK: API
extension DetailNotificationViewModel {
    
    //TODO: Call
    private func detail(){
        guard let code = getDetailData()?.messageCode else { return }
        NotificationManager.share().mark(code: code, completion: { [weak self] data in
            self?.detailDataModel.value = data
        })
    }
}
