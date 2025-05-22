//
//  ResultTicketViewModel.swift
//  IMT-iOS
//
//  Created by dev on 27/04/2023.
//

import Foundation
import UIKit

protocol ResultTicketViewModelProtocol {
    var onUpdateImage: ObservableObject<UIImage> { get set }
    var onGotoWarning: JBundle { get set }
    var onGotoScan: JVoid { get set }
    var onEnableButton: ObservableObject<Bool> { get set }
    
    func create()
    func showWarning(_ controller: ResultTicketVC?, data: [IListQRModel]?)
    func enableButton()}

class ResultTicketViewModel:BaseViewModel {
    
    var onUpdateImage: ObservableObject<UIImage> = ObservableObject<UIImage>(UIImage())
    var onEnableButton: ObservableObject<Bool> =  ObservableObject<Bool>(false)
    
    var onGotoWarning: JBundle =  { _  in  }
    var onGotoScan: JVoid = { }
    var maximumNumberOfMemorial: Int = 0
    
    private var object: RegisterQRModel!
    
    init(bundle: [HomeBundleKey: Any]?) {
        guard let bundle = bundle, let object = bundle[.object] as? RegisterQRModel else { return }
        self.object = object
        onUpdateImage.value = object.image.convertBase64StringToImage()
    }
}

extension ResultTicketViewModel: ResultTicketViewModelProtocol {
    func enableButton() {
        onEnableButton.value = true
    }
    
    func create() {
        manager.call(endpoint: .listQR, completion: responseListQR)
    }
    
    func showWarning(_ controller: ResultTicketVC?, data: [IListQRModel]?) {
        guard let controller = controller else { return }
        controller.showWarningLimitTicket(limit: maximumNumberOfMemorial)
    }
}

extension ResultTicketViewModel{
    private func responseListQR(_ data: [IListQRModel]?, success: Bool) {
        guard let data = data else { return }
        Task { @MainActor in
            do {
                self.maximumNumberOfMemorial = try await getSystemValue().getValueFromAysy01(key: .maximumNumberOfMemorial)?.integer() ?? 0
                if(data.count >= self.maximumNumberOfMemorial) {
                    let bundle = ["data": data]
                    self.onGotoWarning(bundle)
                } else{
                    self.onGotoScan()
                }
            } catch(let error) {
                showMessageError(message: error.localizedDescription)
            }
        }
    }
    
    private func getSystemValue() async throws -> ResponseSysEnv {
        return try await withCheckedThrowingContinuation { continuation in
            manager.call(endpoint: .sysEnv, showLoading: false, completion: responseSysEnv)
            
            func responseSysEnv(_ response: ResponseSysEnv?, success: Bool) {
                if let response = response {
                    continuation.resume(returning: response)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
}
