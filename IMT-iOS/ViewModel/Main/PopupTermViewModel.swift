//
//  PopupTermViewModel.swift
//  IMT-iOS
//
//  Created by dev on 16/03/2023.
//

import Foundation
import UIKit

protocol PopupTermViewModelProtocol: IMTForceUpdateProtocol {
    var checked: ObservableObject<Bool> { get set }
    var allowCheck: ObservableObject<Bool> { get set }
    var onAttributeHTML: ObservableObject<NSAttributedString> { get set }
    
    func gotoLogin(_ controller: PopupTermVC)
}

class PopupTermViewModel: PopupTermViewModelProtocol {
    
    var checked: ObservableObject<Bool> = ObservableObject<Bool>(false)
    var allowCheck: ObservableObject<Bool> = ObservableObject<Bool>(false)
    var onAttributeHTML: ObservableObject<NSAttributedString> = ObservableObject<NSAttributedString>(NSAttributedString())
    var onDidResultCheckVerion: ((AppVersionUpdateState) -> Void) = { _ in }
    
    init() {
        onAttributeHTML.value = attributeHTML()
        checkVersion()
    }
    
    func gotoLogin(_ controller: PopupTermVC) {
        controller.pop()
        Utils.setUserDefault(value: "false", forKey: .showTerm)
        Utils.postObserver(.didLoginSuccessfully, object: true)
    }
    
    func continueWhenCancelUpgrade(_ controller: BaseViewController?) {
        
    }
}

extension PopupTermViewModel {
    private func attributeHTML() -> NSAttributedString? {
        if let filePath = Bundle.main.path(forResource: "termsandusage", ofType: "txt") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                let encoding = NSString.stringEncoding(for: data, encodingOptions: nil, convertedString: nil, usedLossyConversion: nil)
                let htmlString = try String(contentsOfFile: filePath, encoding: String.Encoding(rawValue: encoding))
                let attributedString = try NSAttributedString(data: htmlString.data(using: .unicode)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                let fontRegular = UIFont.appFontW3Size(14)
                mutableAttributedString.addAttribute(.paragraphStyle, value: fontRegular , range: NSRange(location: 0, length: mutableAttributedString.length))
                
                let paragraphLineSpacing = NSMutableParagraphStyle()
                paragraphLineSpacing .lineSpacing = 5.5
                mutableAttributedString.addAttribute(.paragraphStyle, value: paragraphLineSpacing , range: NSRange(location: 0, length: mutableAttributedString.length))
                
                return mutableAttributedString
            } catch {
                print("Error reading HTML file: \(error)")
            }
        }
        
        return nil
    }
}
