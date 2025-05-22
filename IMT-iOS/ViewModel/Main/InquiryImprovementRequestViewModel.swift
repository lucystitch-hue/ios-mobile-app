//
//  InquiryImprovementRequestViewModel.swift
//  IMT-iOS
//
//  Created by dev on 22/05/2023.
//

import Foundation
import UIKit

protocol InquiryImprovementRequestViewModelProtocol {
    var indexCategory: Int { get set }
    var indexDeviceUsing: Int { get set }
    var indexOperatingSystem: Int { get set }
    
    var category: ObservableObject<[String]> { get set }
    var deviceUsing: ObservableObject<[String]> { get set }
    var operatingSystem: ObservableObject<[String]> { get set }
    var meDataModel: ObservableObject<(data: MeDataModel?, isIntial: Bool)> { get set }
    
    func removeObserverNotificationCenter()
    func loadData()
}

class InquiryImprovementRequestViewModel: BaseViewModel {
    
    var indexCategory: Int = -1
    var indexDeviceUsing: Int = -1
    var indexOperatingSystem: Int = -1
    
    var category: ObservableObject<[String]> = ObservableObject<[String]>([])
    var deviceUsing: ObservableObject<[String]> = ObservableObject<[String]>([])
    var operatingSystem: ObservableObject<[String]> = ObservableObject<[String]>([])
    var meDataModel: ObservableObject<(data: MeDataModel?, isIntial: Bool)> = ObservableObject<(data: MeDataModel?, isIntial: Bool)>((nil, true))
    private var group: DispatchGroup?
    
    override init() {
        super.init()
        self.category.value = getCategory()
        self.deviceUsing.value = getDeviceUsing()
        self.operatingSystem.value = getOperatingSystem()
    }
    
    override func removeObserver() {
        super.removeObserver()
        Utils.removeObserver(self, name: .callAPIMe)
    }
    
    override func refreshData() {
        callAPI()
        Utils.onObserver(self, selector: #selector(getMe), name: .callAPIMe)
    }
    
}

extension InquiryImprovementRequestViewModel {
    private func getCategory() -> [String] {
        var category = Category.allCases.map({ $0.rawValue })
        category.insert(.placeholder.selectCategory, at: 0)
        return category
    }
    
    private func getDeviceUsing() -> [String] {
        var deviceUsing = DeviceUsing.allCases.map({ $0.rawValue })
        deviceUsing.insert(.placeholder.selectDeviceUsing, at: 0)
        return deviceUsing
    }
    
    private func getOperatingSystem() -> [String] {
        var operatingSystem = OperatingSystem.allCases.map({ $0.rawValue })
        operatingSystem.insert(.placeholder.selectOperatingSystem, at: 0)
        return operatingSystem
    }
    
    //TODO: Call
    private func callAPI() {
        self.group = DispatchGroup()
        
        Utils.showProgress()
        
        //Me
        group?.enter()
        getMe()
        
        group?.notify(queue: .main) { [weak self] in
            self?.group = nil
            Utils.hideProgress()
        }
        
    }
    
    @objc private func getMe(_ notification: NSNotification? = nil) {
        manager.call(endpoint: .getUser, showLoading: false, completion: responseMe)
    }
    
    //TODO: Response
    private func response<R: BaseResponse>(_ response: R?, successCompletion:@escaping((R) -> Void)) {
        guard let response = response else { return }
        if(response.success) {
            successCompletion(response)
            group?.leave()
        } else {
            group?.leave()
            guard let message = response.message else { return }
            showMessageError(message: message)
            
        }
    }
    
    private func responseMe(_ response: ResponseMe?, success: Bool) {
        self.response(response) { [weak self] res in
            self?.meDataModel.value = (res.data, false)
            guard let meDataModel = self?.meDataModel.value?.data else { return }
            Utils.postObserver(.reloadMe, object: meDataModel)
        }
    }
}

extension InquiryImprovementRequestViewModel : InquiryImprovementRequestViewModelProtocol{
    func removeObserverNotificationCenter(){
        removeObserver()
    }
    
    func loadData() {
        refreshData()
    }
}
