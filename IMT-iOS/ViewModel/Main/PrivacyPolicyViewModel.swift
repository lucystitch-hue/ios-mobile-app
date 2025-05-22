//
//  PrivacyPolicyViewModel.swift
//  IMT-iOS
//
//  Created by dev on 16/05/2023.
//

import Foundation
import UIKit

protocol PrivacyPolicyViewModelProtocol {
    
    var onAttributeHTML: ObservableObject<NSAttributedString> { get set }
}

class PrivacyPolicyViewModel: PrivacyPolicyViewModelProtocol {
    
    var onAttributeHTML: ObservableObject<NSAttributedString> = ObservableObject<NSAttributedString>(NSAttributedString())
    
    init() {
        onAttributeHTML.value = attributeHTML()
    }
}

extension PrivacyPolicyViewModel {
    private func attributeHTML() -> NSAttributedString? {
        if let filePath = Bundle.main.path(forResource: "privacy", ofType: "txt") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                let encoding = NSString.stringEncoding(for: data, encodingOptions: nil, convertedString: nil, usedLossyConversion: nil)
                let htmlString = try String(contentsOfFile: filePath, encoding: String.Encoding(rawValue: encoding))
                let attributedString = try NSAttributedString(data: htmlString.data(using: .unicode)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                
                let fontBold = UIFont.appFontW6Size(15)
                let fontRegular = UIFont.appFontW3Size(13)
                
                mutableAttributedString.addAttribute(.font, value: fontBold, range: NSRange(location: 0, length: 18))
                mutableAttributedString.addAttribute(.paragraphStyle, value: fontRegular , range: NSRange(location: 18, length: mutableAttributedString.length-50))
                
                let rangeTitleStyle = NSMutableParagraphStyle()
                rangeTitleStyle.alignment = .center
                mutableAttributedString.addAttribute(.paragraphStyle, value:rangeTitleStyle, range: NSRange(location: 0, length: 18))
                
                let paragraphLineSpacing = NSMutableParagraphStyle()
                paragraphLineSpacing .lineSpacing = 5.5
                mutableAttributedString.addAttribute(.paragraphStyle, value: paragraphLineSpacing , range: NSRange(location: 18, length: mutableAttributedString.length-50))
                
                return mutableAttributedString
                
            } catch {
                print("Error reading HTML file: \(error)")
            }
        }
        
        return nil
    }
}
