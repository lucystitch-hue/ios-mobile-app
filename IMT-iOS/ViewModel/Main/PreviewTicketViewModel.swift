//
//  PreviewTicketViewModel.swift
//  IMT-iOS
//
//  Created by dev on 02/04/2023.
//

import Foundation
import UIKit
import Photos
import FBSDKShareKit
import Social

protocol PreviewTicketViewModelProtocol {
    
    var onUpdateTicket: ObservableObject<ViewQRModel> { get set }
    var onUpdateControl: ObservableObject<IListQRModel> { get set}
    var onSavePhotoSuccess: ObservableObject<Bool> { get set }
    
    func share(_ controller: PreviewTicketVC, image imageTicket : UIImage?, type: SNSType)
    func attributeDate(_ date: String) -> NSAttributedString
    func saveImageToPhone(_ imvTicket:UIImageView!)
    func remove(_ controller: PreviewTicketVC)
    func next()
    func previous()
    func getTitlePage() -> String
}

class PreviewTicketViewModel: BaseViewModel {
    
    var onUpdateTicket: ObservableObject<ViewQRModel> = ObservableObject<ViewQRModel>(ViewQRModel(json: []))
    var onUpdateControl: ObservableObject<IListQRModel> = ObservableObject<IListQRModel>(IListQRModel(json: []))
    var onSavePhotoSuccess: ObservableObject<Bool> = ObservableObject<Bool>(false)
    
    private var bundle: [HomeBundleKey: Any]?
    private var listQR: [IListQRModel] = []
    private var index: Int = 0
    
    init(bundle: [HomeBundleKey: Any]?, lbDateTime:IMTLabel!, lbName: IMTLabel!, btnGrade: UIButton!) {
        super.init()
        self.bundle = bundle
        guard let list = getListQRCode(bundle) else { return }
        guard let index = getIndex(bundle) else { return }
        
        self.listQR = list
        self.index = index
        
        loadAt(index)
    }
}

//MARK: Private
extension PreviewTicketViewModel {
    private func responseViewQR(_ response: ViewQRModel?, success: Bool) {
        onUpdateTicket.value = response
    }
    
    private func getValue(_ bundle: [HomeBundleKey: Any]) -> IListQRModel? {
        return bundle[.listQRModel] as? IListQRModel
    }
    
    private func getListQRCode(_ bundle: [HomeBundleKey: Any]?) -> [IListQRModel]? {
        guard let dict = bundle?[.listQRModel] as? [String: Any] else { return nil }
        guard let list = dict["list"] as? [IListQRModel] else { return nil }
        return list
    }
    
    private func getIndex(_ bundle: [HomeBundleKey: Any]?) -> Int? {
        guard let dict = bundle?[.listQRModel] as? [String: Any] else { return nil }
        guard let index = dict["index"] as? Int else { return nil }
        return index
    }
    
    private func removeTicket(_ item: IListQRModel?, controller: PreviewTicketVC?) {
        guard let item = item else { return }
        Utils.showProgress(false)
        manager.call(endpoint: .deleteQR(bakenId: item.memorialId), showLoading: false, completion: responseDeleteQR(_:success:))
        
        func responseDeleteQR(_ response: DeleteQRModel?, success: Bool) {
            if let status = response?.status, status == "OK" {
                Utils.mainAsyncAfter(10) {
                    Utils.hideProgress()
                    controller?.onDissmiss?()
                }
            }
        }
    }
    
    private func loadAt(_ index: Int) {
        let item = self.listQR[index]
        guard let memorialId = item.memorialId else { return }
        
        onUpdateControl.value = item
        manager.call(endpoint: .viewQR(bakenId: memorialId), completion: responseViewQR(_:success:))
    }
}

extension PreviewTicketViewModel: PreviewTicketViewModelProtocol {
    func share(_ controller: PreviewTicketVC, image imageTicket: UIImage?, type: SNSType) {
        guard let imageTicket = imageTicket else { return }

        if (type.installed()) {
            SNSShare.post(type: type, data: SNSShareData("#IMTApp #TicketMemorial", images: [imageTicket]), controller: controller)

        } else {
            guard let url = type.url() else { return }
            controller.transitionFromSafari(url)
        }
    }
    
    func attributeDate(_ date : String) -> NSAttributedString {
        let str = "Registration Date:" + date
        let attributedString = NSMutableAttributedString(string: str)
        let range1 = NSRange(location: 0, length: 5)
        attributedString.addAttribute(.font, value: UIFont.appFontW4Size(15), range: range1)
        let range2 = NSRange(location: 5, length: str.count - 5)
        attributedString.addAttribute(.font, value: UIFont.appFontNumberBoldSize(15), range: range2)
        return attributedString
    }
    
    func saveImageToPhone(_ imvTicket:UIImageView! ) {
        guard let image = imvTicket.image else {
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    PHPhotoLibrary.shared().performChanges({
                        let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                        request.creationDate = Date()
                    }) { success, error in
                        if success {
                            self.onSavePhotoSuccess.value = true
                        } else if let error = error {
                            print("Error saving image: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                Utils.mainAsync {
                    self.showMessageError(message: IMTErrorMessage.permissionPhotoLibary.rawValue)
                }
            }
        }
    }
    
    func remove(_ controller: PreviewTicketVC) {
        controller.showWarningWhenDeleteSingleTicket { [weak self] (actionType, warnVC) in
            guard let actionType = actionType else { return }
            
            if(actionType == .ok) {
                guard let item = self?.onUpdateControl.value else { return }
                self?.removeTicket(item, controller: controller)
            }
        }
    }
    
    func next() {
        let max = listQR.count
        
        if(index + 1 < max) {
            index += 1
            loadAt(index)
        }
        
    }
    
    func previous() {
        let min = 0
        if(index - 1 >= min) {
            index -= 1
            loadAt(index)
        }
    }
    
    func getTitlePage() -> String {
        let current = index + 1
        let max = listQR.count
        
        return "\(current)/\(max)"
    }
}
