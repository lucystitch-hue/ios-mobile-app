//
//  BettingTicketMemorialCameraViewModel.swift
//  IMT-iOS
//
//  Created by dev on 17/04/2023.
//

import Foundation
import AudioToolbox
import UIKit

enum ScanQRToRegisterTicketValidate: String {
    case success = ""
    case invalid = "Invalid QR code"

}

protocol ScanQRToRegisterTicketViewModelProtocol {
    var step: ObservableObject<QRCodeStep> { get set }
    var onComplete:((ScanQRToRegisterTicketValidate, RegisterQRModel?) -> Void) { get set }
    var onShowTakePhoto: ObservableObject<Bool> { get set }
    
    func updateCode(_ code: String, controller: ScanQRToRegisterTicketVC)
    func start(_ controller: ScanQRToRegisterTicketVC?, allowCamera allow: Bool)
    func scan(_ controller: ScanQRToRegisterTicketVC)
    func gotoGuide(_ step: QRCodeStep, controller: ScanQRToRegisterTicketVC?)
    func startCamera(controller: ScanQRToRegisterTicketVC?)
    func showWarning(controller: ScanQRToRegisterTicketVC?)
}

class ScanQRToRegisterTicketViewModel: BaseViewModel {
    var onShowMessage: ((String) -> Void) = { _ in }
    var onComplete: ((ScanQRToRegisterTicketValidate, RegisterQRModel?) -> Void) = { _,_ in }
    var onShowTakePhoto: ObservableObject<Bool> = ObservableObject<Bool>(false)
    var step: ObservableObject<QRCodeStep> = ObservableObject<QRCodeStep>(.left)
    
    private var allowScan: Bool = false
    private var leftQRCode: String = ""
    private var rightQRCode: String = ""
    private var cacheCode: String = ""
    
    private func registerQRCode(left leftQRCode: String, right rightQRCode: String) {
        let value = "\(leftQRCode)\(rightQRCode)"
        manager.call(endpoint: .registQR(bakenId: value), showError: false, completion: responseRegister)
    }
    
    private func responseRegister(_ data: RegisterQRModel?, success: Bool) {
        if let data = data, let _ = data.memorialId, success {
            onComplete(.success, data)
        } else {
            onComplete(.invalid, nil)
        }
    }
    
    private func clearData() {
        allowScan = false
        leftQRCode = ""
        rightQRCode = ""
        cacheCode = ""
    }
}

extension ScanQRToRegisterTicketViewModel: ScanQRToRegisterTicketViewModelProtocol {
    func updateCode(_ code: String, controller: ScanQRToRegisterTicketVC) {
        if(self.allowScan == true) {
            self.cacheCode = code
        }
        
        self.onShowTakePhoto.value = !code.isEmpty
    }
    
    func start(_ controller: ScanQRToRegisterTicketVC?, allowCamera allow: Bool) {
        guard let controller = controller else { return }
        var showGuide = UserManager.share().showGuideQRCode()
        
        let delay = Constants.System.delayCamera
        
        if(allow && showGuide) {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                self?.gotoGuide(.left, controller: controller)
            })
        } else if(allow && !showGuide) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [weak self] in
                self?.startCamera(controller: controller)
            })
        } else {
            controller.dismiss(animated: true)
        }
    }
    
    func scan(_ controller: ScanQRToRegisterTicketVC) {
        if(leftQRCode.isEmpty) {
            allowScan = false
            leftQRCode = cacheCode
            step.value = .right
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            controller.IMTQRCode.stop()
            
            //It allow scan right QR after 0.5s
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.SystemConfigure.delayCamera) { [weak self] in
                self?.cacheCode = ""
                self?.onShowTakePhoto.value = false
                self?.allowScan = true
                controller.IMTQRCode.start(controller.view)
            }
        } else {
            controller.IMTQRCode.stop()
            allowScan = false
            rightQRCode = cacheCode
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            registerQRCode(left: leftQRCode, right: rightQRCode)
        }
    }
    
    func gotoGuide(_ step: QRCodeStep, controller: ScanQRToRegisterTicketVC?) {
        guard let controller = controller else { return }
        let vc = ScanQRCodeGuideVC(step: step)

        vc.onDidClose = { [weak self] step in
            if(step == .left) {
                self?.gotoGuide(.right, controller: controller)
            } else {
                self?.allowScan = true
                controller.IMTQRCode.start(controller.view)
            }
        }
        
        controller.presentOverFullScreen(vc, animate: false)
    }
    
    func startCamera(controller: ScanQRToRegisterTicketVC?) { //
        guard let controller = controller else { return }
        clearData()
        self.allowScan = true
        controller.IMTQRCode.start(controller.view)
    }
    
    func showWarning(controller: ScanQRToRegisterTicketVC?) {
        guard let controller = controller else { return }
        controller.showWarningErrorReadingQR {
            controller.dismiss(animated: true)
        }
    }
    
}


