//
//  BettingTicketMemorialViewModel.swift
//  IMT-iOS
//
//  Created by dev on 17/03/2023.
//

import Foundation
import AVFoundation
import UIKit

protocol MemorialViewModelProtocol {
    var onGotoResultRegisterTicket:((_ qrInfo: RegisterQRModel) -> Void) { get set }
    var onGotoScanQR: ObservableObject<Bool> { get set}
    var onAttribute: ObservableObject<NSAttributedString> { get set }
    var onGotoWarning: JBundle { get set }
    var onGotoScan: JVoid { get set }
    
    func gotoScanQRToRegisterTicket(_ controller: MemorialVC?)
    func resgister()
    func showWarning(_ controller: MemorialVC?, data: [IListQRModel]?)
    
}

class MemorialViewModel :BaseViewModel{
    var onAttribute: ObservableObject<NSAttributedString> = ObservableObject<NSAttributedString>(NSAttributedString())
    var onGotoResultRegisterTicket: ((_ qrInfo: RegisterQRModel) -> Void) = { _ in }
    var onGotoScanQR: ObservableObject<Bool> = ObservableObject<Bool>(false)
    var onGotoWarning: JBundle =  { _  in  }
    var onGotoScan: JVoid = { }

    var maximumNumberOfMemorial: Int = 0
    
    init(bundle: [HomeBundleKey: Any]?) {
        super.init()
        if let openScanQR = bundle?[.openScanQR] as? Bool, openScanQR == true {
            onGotoScanQR.value = openScanQR
        } else {
            onGotoScanQR.value = false
        }
        
        onAttribute.value = self.attributeText()
    }
}

extension MemorialViewModel: MemorialViewModelProtocol {

    func gotoScanQRToRegisterTicket(_ controller: MemorialVC?) {
        Utils.permissionCamera { [weak self] allow in
            if(allow) {
                guard let controller = controller else { return }
                let vc = ScanQRToRegisterTicketVC()
                
                vc.gotoResultRegisterTicket = { [weak self] qrCode in
                    self?.onGotoResultRegisterTicket(qrCode)
                }
                
                vc.onShowMessage = { [weak self] message in
                    self?.showMessageError(message: message)
                }
                
                controller.presentOverFullScreen(vc, animate: false)
            } else {
                self?.showMessageError(message: .error.permissionCamera)
            }
        }
    }
    
    func resgister() {
        manager.call(endpoint: .listQR, completion: responseListQR)
    }
    
    func showWarning(_ controller: MemorialVC?, data: [IListQRModel]?) {
        guard let controller = controller else { return }
        controller.showWarningLimitTicket(limit: self.maximumNumberOfMemorial)
    }
    
    private func attributeText()->NSAttributedString?{
        let attributedString = NSMutableAttributedString(string: .MemorialString.desMemorial)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment =  .left
        paragraphStyle.lineSpacing = 7
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
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
