//
//  IMTSlider.swift
//  IMT-iOS
//
//  Created on 10/07/2024.
//
    

import Foundation
import UIKit

enum IMTSliderDirection {
    case left
    case right
}

protocol IMTSliderDelegate {
    func slider(_ slider: IMTSlider, didSelectText tag: Int)
}

extension IMTSliderDelegate {
    func slider(_ slider: IMTSlider, didSelectText tag: Int) {
        
    }
}

class IMTSlider: UIView {
    
    private struct Constants {
        static let kDefaultLabelBufferSpace: CGFloat = 20
        static let kDefaultPixelsPerSecond: Double = 30.0
    }
    
    public var scrollDirection = IMTSliderDirection.right {
        didSet {
            scrollLabelIfNeeded()
        }
    }
    
    public var scrollSpeed = Constants.kDefaultPixelsPerSecond {
        didSet {
            scrollLabelIfNeeded()
        }
    }

    public var labelSpacing = Constants.kDefaultLabelBufferSpace
    
    public var animationOptions: UIView.AnimationOptions = UIView.AnimationOptions.curveLinear
    
    public var scrolling = false
    
    public var delegate: IMTSliderDelegate?
    
    public var textColor: UIColor? {
        get {
            return labels.first?.textColor
        }
        set {
            for lab in labels {
                lab.textColor = newValue
            }
        }
    }
    
    public var font: UIFont? {
        get {
            return labels.first?.font
        }
        set {
            for lab in labels {
                lab.font = newValue
            }
            refreshLabels()
            invalidateIntrinsicContentSize()
        }
    }
    
    public var texts: [String] = [] {
        didSet {
            labels.removeAll()
            for index in 0...texts.lastIndex {
                let label = UILabel()
                label.text = texts[index]
                label.tag = index
                labels.append(label)
            }
            refreshLabels()
        }
    }
    
    private var labels: [UILabel] = [] {
        didSet {
            for label in labels {
                label.autoresizingMask = autoresizingMask
                label.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel))
                label.addGestureRecognizer(tapGesture)
                self.scrollView.addSubview(label)
            }
        }
    }
    
    lazy public private(set) var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: self.bounds)
        sv.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        sv.backgroundColor = UIColor.clear
        return sv
    }()
    
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    @objc public func scrollLabelIfNeeded() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.texts.isEmpty == true {
                return
            }
            self.scrollLabelIfNeededAction()
        }
    }
    
    func scrollLabelIfNeededAction() {
        var offset: CGFloat = CGFloat(0)
        
        for index in 0...texts.lastIndex {
            let label = labels[index]
            offset += label.bounds.width
            if index != texts.lastIndex {
                offset += labelSpacing
            }
        }
        
        //        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(IMTSlider.scrollLabelIfNeeded), object: nil)
        
        self.scrollView.layer.removeAllAnimations()
        let doScrollLeft = self.scrollDirection == IMTSliderDirection.left
        self.scrollView.contentOffset = doScrollLeft ? .zero : CGPoint(x: offset + self.labelSpacing, y: 0)
        
        self.scrolling = true
        
        // Animate the scrolling
        let duration = Double(offset) / self.scrollSpeed
        
        timer?.invalidate()
        timer = nil
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: duration / 1000, repeats: true, block: { timer in
                let offsetTodo = doScrollLeft ? CGPoint(x: offset + self.labelSpacing, y: 0) : CGPoint.zero
                if Darwin.round(self.scrollView.contentOffset.x) == Darwin.round(offsetTodo.x) {
                    self.scrollView.contentOffset = doScrollLeft ? .zero : CGPoint(x: offset + self.labelSpacing, y: 0)
                    return
                }
                self.scrollView.contentOffset.x += doScrollLeft ? 0.5 : -0.5
            })
        }
    }
}

// MARK: PRIVATE
extension IMTSlider {
    private func commonInit() {
        addSubview(scrollView)
        
        self.scrollView.isScrollEnabled = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.observeApplicationNotifications()
        }
    }
    
    @objc private func refreshLabels() {
        var offset: CGFloat = CGFloat(0)
        
        for label in labels {
            label.sizeToFit()
            
            var frame = label.frame
            frame.origin = CGPoint(x: offset, y: 0)
            frame.size.height = bounds.height
            label.frame = frame
            
            label.center = CGPoint(x: label.center.x, y: Darwin.round(center.y - self.frame.minY))
            
            offset += label.bounds.width + labelSpacing

            label.isHidden = false
        }
        
        scrollView.contentOffset = CGPoint.zero
        scrollView.layer.removeAllAnimations()
        
        if offset > (bounds.width * 2) {
            scrollView.contentSize.width = offset
            scrollView.contentSize.height = self.bounds.height
            scrollLabelIfNeeded()
        } else {
            for index in 0...texts.lastIndex {
                let label = UILabel()
                label.text = texts[index]
                label.tag = index
                label.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel))
                label.addGestureRecognizer(tapGesture)
                labels.append(label)
            }
            self.scrollView.layer.removeAllAnimations()
            refreshLabels()
        }
    }
    
    private func observeApplicationNotifications() {
//        NotificationCenter.default.removeObserver(self)
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(IMTSlider.scrollLabelIfNeeded),
//            name: UIApplication.willEnterForegroundNotification,
//            object: nil
//        )
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(IMTSlider.scrollLabelIfNeeded),
//            name: UIApplication.didBecomeActiveNotification,
//            object: nil
//        )
    }
    
    @objc private func tapLabel(sender: UITapGestureRecognizer) {
        guard let view = sender.view as? UILabel else { return }
        print("#tap gesture \(view.text ?? "")")
        delegate?.slider(self, didSelectText: view.tag)
    }
}
