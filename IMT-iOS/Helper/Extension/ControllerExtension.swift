//
//  ControllerExtension.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import Foundation
import UIKit
import Toast_Swift

extension UIViewController {
    func push(_ controller: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func present(controller: UIViewController, animated: Bool = true) {
        self.present(controller, animated: animated)
    }
    
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
    func setGradientBackground() {
        
        let colorTop = UIColor.main.cgColor
        let colorBottom = UIColor.sacramentoGreen.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = UIScreen.main.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    public func takeScreenshot() -> UIImage {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    public func presentOverFullScreen(_ controller: UIViewController, animate:Bool = false, completion:@escaping() -> Void = { }) {
        controller.modalPresentationStyle = .overFullScreen;
        self.present(controller, animated: animate, completion: completion);
    }
    
    public func add(_ child: UIViewController) {
        self.addChild(child)
        child.didMove(toParent: self)
    }
    
    public func showToastBottom(_ text: String, hasImage: Bool = true) {
        var style = Utils.getToastStyle()
        var image: UIImage?
        
        if(hasImage) {
            style.imageSize = CGSize(width: 20.0, height: 15.0)
            image = .icCircleApp
        }
        
        self.view.makeToast(text, duration: 2.0, position: .bottom, image: image, style: style)
    }
    
    func configAttribute(text: String, alignmentText: String, lineSpacing:Int = 7)->NSAttributedString?{
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        
        if(alignmentText == "center"){
            paragraphStyle.alignment =  .center
        } else if (alignmentText == "left" ){
            paragraphStyle.alignment =  .left
        }
        
        paragraphStyle.lineSpacing = CGFloat(lineSpacing)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        return attributedString
    }
    
    public func configPlaceholder(withText text: String) -> NSAttributedString {
        let attributedString = NSAttributedString(string: text, attributes: [
            .foregroundColor: UIColor.quickSilver,
            .font: UIFont.appFontW6Size(13.0)
        ])
        return attributedString
    }
    
    public func getName() -> String {
        return String(describing: type(of: self))
    }
    
    func pop(ofClass: AnyClass, animated: Bool = true) {
        guard let navigationController = self.navigationController else { return }
        if let vc = navigationController.viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            navigationController.popToViewController(vc, animated: animated)
      }
    }

}
