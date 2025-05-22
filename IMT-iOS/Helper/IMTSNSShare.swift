//
//  SNSShare.swift
//  IMT-iOS
//
//  Created by dev on 13/09/2023.
//

import Foundation
import UIKit
import Social
import FBSDKShareKit
import Photos

public enum SNSType: String, CaseIterable {
    case facebook = "fb://"
    case instagram = "instagram://"
    case twitter = "twitter://"
    case line = "line://"
    
    func appUrl() -> URL {
        return URL(string: rawValue)!
    }
    
    func url() -> String? {
        var strURL: String
        switch self {
        case .facebook:
            strURL = "https://m.facebook.com"
        case .instagram:
            strURL = "https://www.instagram.com/"
        case .twitter:
            strURL = "https://twitter.com/"
        case .line:
            strURL = "https://line.me/en/"
        }
        return strURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    }
    
    func urlEncode() -> URL? {
        let strURL = url()
        guard let strURL = strURL,
              let encode = strURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
              let webURL = URL(string: encode) else { return nil}
        
        return webURL
    }
    
    func installed() -> Bool {
        guard let url = URL(string: rawValue) else { return false }
        
        return UIApplication.shared.canOpenURL(url)
    }
}

public enum SNSShareResult {
    case success
    case failure(SNSShareErrorType)
}

public enum SNSShareErrorType {
    case notAvailable(SNSType)
    case emptyData
    case cancelled
    case uriEncodingError
    case unknownError
    case permissionDenied
}

public typealias SNSSharePostCompletion = (SNSShareResult) -> Void

public class SNSShareData {
    
    public var text: String = ""
    public var images: [UIImage] = [UIImage]()
    public var urls: [URL] = [URL]()
    
    public init() {
    }
    
    public init(_ text: String) {
        self.text = text
    }
    
    public init(_ images: [UIImage]) {
        self.images = images
    }
    
    public init(_ urls: [URL]) {
        self.urls = urls
    }
    
    public init(_ text: String, images: [UIImage]) {
        self.text = text
        self.images = images
    }
    
    public init(text: String, images: [UIImage], urls: [URL]) {
        self.text = text
        self.images = images
        self.urls = urls
    }
    
    public typealias BuilderClosure = (SNSShareData) -> Void
    public init(builder: BuilderClosure) {
        builder(self)
    }
    
    public var isEmpty: Bool {
        return text.isEmpty && images.isEmpty && urls.isEmpty
    }
    
}

public class SNSShare {
    public class func available(type: SNSType) -> Bool {
        return type.installed()
    }
    
    public class func post(type: SNSType, data: SNSShareData, controller: UIViewController, completion: @escaping SNSSharePostCompletion = { _ in }) {
        guard available(type: type) else {
            completion(.failure(.notAvailable(type)))
            return
        }
        
        guard !data.isEmpty else {
            completion(.failure(.emptyData))
            return
        }
        
        switch type {
        case .facebook:
            postFacebook(data: data, controller: controller, completion: completion)
            break
        case .instagram:
            postInstagram(data: data, controller: controller, completion: completion)
            break
        case .twitter:
            postTwitter(data: data, controller: controller, completion: completion)
            break
        case .line:
            postLine(data: data, controller: controller, completion: completion)
            break
        }
    }
    
    private class func postFacebook(data: SNSShareData, controller: UIViewController, completion: SNSSharePostCompletion) {
        if data.images.count > 0 {
            var photos = [SharePhoto]()
            data.images.forEach { image in
                photos.append(SharePhoto(image: image, isUserGenerated: true))
            }
            let content = SharePhotoContent()
            content.photos = photos
            
            if let text = data.text.split(separator: " ").first {
                content.hashtag = Hashtag(String(text))
            }
            
            if let url = data.urls.first {
                content.contentURL = url
            }
            
            let dialog = ShareDialog(viewController: controller, content: content, delegate: nil)
            guard dialog.canShow else { return }
            dialog.show()
        } else {
            let content = ShareLinkContent()
            if let text = data.text.split(separator: " ").first {
                content.hashtag = Hashtag(String(text))
            }
            
            if let url = data.urls.first {
                content.contentURL = url
            }
            
            let dialog = ShareDialog(viewController: controller, content: content, delegate: nil)
            guard dialog.canShow else { return }
            dialog.show()
        }
    }
    
    private class func postInstagram(data: SNSShareData, controller: UIViewController, completion: @escaping SNSSharePostCompletion) {
        guard let image = data.images.first else {
            completion(.failure(.emptyData))
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                Utils.mainAsync {
                    Utils.showProgress()
                }
                PHPhotoLibrary.shared().performChanges({
                    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    request.creationDate = Date()
                }) { success, error in
                    Utils.mainAsync {
                        Utils.hideProgress()
                        if success {
                            let fetchOptions = PHFetchOptions()
                            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                            
                            if let lastAsset = fetchResult.firstObject {
                                let localIdentifier = lastAsset.localIdentifier
                                let instagramURLString = "instagram://library?LocalIdentifier=" + localIdentifier
                                
                                guard let _ = URL(string: instagramURLString) else {
                                    completion(.failure(.uriEncodingError))
                                    return
                                }
                                
                                if let controller = controller as? BaseViewController {
                                    controller.transitionFromSafari(instagramURLString)
                                } else {
                                    completion(.failure(.unknownError))
                                }
                            } else {
                                completion(.failure(.unknownError))
                            }
                        } else if let _ = error {
                            completion(.failure(.cancelled))
                        }
                    }
                }
            } else {
                completion(.failure(.permissionDenied))
            }
        }
    }
    
    private class func postTwitter(data: SNSShareData, controller: UIViewController, completion: @escaping SNSSharePostCompletion) {
        guard let viewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else {
            return
        }
        
        viewController.completionHandler = { result in
            switch result {
            case .done: completion(.success)
            case .cancelled: completion(.failure(.cancelled))
            @unknown default:
                completion(.failure(.unknownError))
            }
        }
        viewController.setInitialText(data.text)
        viewController.modalPresentationStyle = .formSheet
        data.images.forEach({ viewController.add(maskImage($0))})
        
        controller.present(viewController, animated: true, completion: nil)
    }
    
    private class func postLine(data: SNSShareData, controller: UIViewController, completion: @escaping SNSSharePostCompletion) {
        var scheme = "line://msg/"
        if let image = data.images.first, let imageData = image.pngData() {
            let pasteboard = UIPasteboard.general
            pasteboard.setData(imageData, forPasteboardType: "public.png")
            scheme += "image/\(pasteboard.name.rawValue)"
        } else {
            var texts = [String]()
            if !data.text.isEmpty {
                texts.append(data.text)
            }
            data.urls.forEach{ texts.append($0.absoluteString) }
            let set = CharacterSet.alphanumerics
            guard let text = texts
                .joined(separator: "\n")
                .addingPercentEncoding(withAllowedCharacters: set) else
            {
                completion(.failure(.uriEncodingError))
                return
            }
            scheme += "text/\(text)"
        }
        
        guard let controller = controller as? BaseViewController else {
            completion(.failure(.unknownError))
            return
        }
        
        controller.transitionFromSafari(scheme)
        completion(.success)
    }
}

//TODO: Utils
extension SNSShare {
    private class func maskImage(_ image: UIImage) -> UIImage {
        let wScreen = UIScreen.main.bounds.size.width
        let wImage = wScreen * 0.75
        
        let imvView = UIImageView(frame: CGRect(x: 0, y: 0, width: wImage, height: wImage))
        imvView.image = image
        imvView.contentMode = .scaleAspectFit
        
        let imv = imvView.toImage()
        return imv
    }
}
