//
//  ViewExtension.swift
//  IMT-iOS
//
//  Created by dev on 08/03/2023.
//

import Foundation
import UIKit

extension UIView {
    static func instantiateView() -> Self {
        let fileName = Self.nameOfClass
        let view = Bundle.main.loadNibNamed(fileName, owner: nil, options: nil)?.first
        return view as! Self
    }
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    func cornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    @nonobjc func round(corners: UIRectCorner, with radius: CGFloat? = nil) {
        let maskLayer = CAShapeLayer()
        let cornerRadius = radius ?? self.bounds.size.height / 2
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func setShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: Utils.scaleWithHeight(1.527))
        layer.shadowRadius = Utils.scaleWithHeight(3.0)
        layer.shadowOpacity = Float(Utils.scaleWithHeight(0.524))
        
    }
    
    func setShadowLogin() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: Utils.scaleWithHeight(1.927))
        layer.shadowRadius = Utils.scaleWithHeight(2.0)
        layer.shadowOpacity = Float(Utils.scaleWithHeight(0.524))
    }
    
    func applySketchShadow( color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2.0
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func rumShineAnimation(animationSpeed: Float = 1.4,
                           direction: DirectionButtonShine = .leftToRight,
                           shineColor: UIColor = .white,
                           cover: Bool = true) {
        
        let lightColor = UIColor.white.withAlphaComponent(0).cgColor
        let shineColorValue = shineColor.withAlphaComponent(1).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [lightColor, shineColorValue, lightColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width * 1.35, height: bounds.height)
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: -0.2, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.1)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        gradientLayer.locations =  [ 0.35,0.45] //[0.4, 0.6]
        gradientLayer.name = "shineLayer"
        let indexLayer = cover ? UInt32(self.layer.sublayers?.count ?? 0) : 0
        self.layer.insertSublayer(gradientLayer, at: indexLayer)
        
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        CATransaction.commit()
    }
    
    func stopShineAnimation(_ cover: Bool = true) {
        let indexLayer = cover ? UInt32(self.layer.sublayers?.count ?? 0) : 0
        let exist = self.layer.sublayers?.contains(where: { $0.name == "shineLayer"}) ?? false
        
        if(exist) {
            self.layer.sublayers?.remove(at: Int(indexLayer - 1))
        }
    }
    
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

extension UIView {
    @IBInspectable var autoRadius: Bool {
        get {
            return self.layer.cornerRadius != 0
        }
        set(value) {
            if(value) {
                let height = self.bounds.size.height
                let heightConstant = self.heightConstraint?.constant ?? 0
                let vHeight = height != 0 ? height : heightConstant
                
                let radius = vHeight.autoScale() * Constants.halfRadius
                self.cornerRadius(radius: radius)
            }
        }
    }
    
    @IBInspectable var shadownViewLogin: Bool {
        get {
            return true
        }
        set {
            if(newValue) {
                self.setShadowLogin()
            }
        }
    }
    
    @IBInspectable var useShadownView: Bool {
        get {
            return true
        }
        set {
            if(newValue) {
                self.setShadow()
            }
        }
    }
    
    @IBInspectable var manualRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set(value) {
            self.cornerRadius(radius: value.autoScale())
        }
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var topConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .top && $0.relation == .equal
            })
        }
        set {
            setNeedsLayout()
        }
    }
}

extension UIView {
    func toImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIView {
    func addSameSizeConstaints(subView view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDirectory = ["subview" : view]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0@999-[subview]-0@999-|", metrics: nil, views: viewDirectory))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0@999-[subview]-0@999-|", metrics: nil, views: viewDirectory))
        
        layoutIfNeeded()
    }
    
    func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func addShadowView() {
        let shadowView = ShadowView(radius: layer.cornerRadius)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        superview?.insertSubview(shadowView, belowSubview: self)
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

private class ShadowView: UIView {
    private var cachedBounds: CGRect = .zero
    private var radius: CGFloat
    
    required init(radius: CGFloat) {
        self.radius = radius
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard cachedBounds != bounds else {
            return
        }
        
        cachedBounds = bounds
        layer.cornerRadius = radius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
