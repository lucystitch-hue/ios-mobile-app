//
//  PurchaseHorseRacingTicketVC.swift
//  IMT-iOS
//
//  Created on 09/04/2024.
//
    

import UIKit

enum PurchaseHorseRacingTicketOption {
    case iPat
    case umaca
}

class PurchaseHorseRacingTicketVC: BaseViewController {
    
    @IBOutlet private weak var vIpat: UIView!
    @IBOutlet private weak var vUmaca: UIView!
    
    var onSelectedOption: ((PurchaseHorseRacingTicketOption) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeAutoRadius(vIpat)
        makeAutoRadius(vUmaca)
    }
    
    private func applyStyle() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.25)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func close(_ gesture: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    @IBAction func actionIpat(_ sender: Any) {
        Utils.logActionClick(.blueInternetVoting)
        dismiss(animated: true) { [weak self] in
            self?.onSelectedOption?(.iPat)
        }
    }
    
    @IBAction func actionUmaca(_ sender: Any) {
        Utils.logActionClick(.greenUmacaSmart)
        dismiss(animated: true) { [weak self] in
            self?.onSelectedOption?(.umaca)
        }
    }
    
    private func makeAutoRadius(_ view: UIView) {
        let radius = min(view.frame.size.width / 2.0, view.frame.size.height / 2.0)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2
        
        view.layer.shadowPath = UIBezierPath(roundedRect: vIpat.bounds, cornerRadius: vIpat.layer.cornerRadius).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
}
