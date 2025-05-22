//
//  ScanQRCodeGuideViewModel.swift
//  IMT-iOS
//
//  Created by dev on 20/04/2023.
//

import Foundation

protocol ScanQRCodeGuideViewModelProtocol {
    var onChecked: ObservableObject<Bool> { get set }
    
    func dismiss(_ controller: ScanQRCodeGuideVC?)

}

class ScanQRCodeGuideViewModel {
    var onChecked: ObservableObject<Bool> = ObservableObject<Bool>(false)
    
    private var step: QRCodeStep!
    
    init(step: QRCodeStep) {
        self.step = step
    }
}

extension ScanQRCodeGuideViewModel: ScanQRCodeGuideViewModelProtocol {
    func dismiss(_ controller: ScanQRCodeGuideVC?) {
        guard let controller = controller else { return }
        
        controller.dismiss(animated: false) { [weak self] in
            if let onDidClose = controller.onDidClose {
                onDidClose(self?.step)
            }
        }
    }

}
