//
//  ScanQRToRegisterTicketVC.swift
//  IMT-iOS
//
//  Created by dev on 16/03/2023.
//

import UIKit
import AVFoundation

class ScanQRToRegisterTicketVC: BaseViewController {
    
    @IBOutlet weak var lblGuide: UILabel!
    @IBOutlet weak var btnScanQR: IMTButton!{
        didSet {
            let image = UIImage(named: "ic_buttonscreen")?.resizedImage(CGSize(width: 75, height: 75))
            self.btnScanQR.setImage(image, for: .normal)
        }
    }
    @IBOutlet weak var vText: IMTView!
    @IBOutlet weak var imvHandPoint: UIImageView!
    
    public var gotoResultRegisterTicket:((RegisterQRModel) -> Void)?
    public var onShowMessage:((String) -> Void)?
    
    public lazy var IMTQRCode: IMTQRCodeProtocol = IMTQRCode()
    private var viewModel: ScanQRToRegisterTicketViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewText()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IMTQRCode.stop()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionScan(_ sender: Any) {
        setupViewText()
        viewModel.scan(self)
    }
}

extension ScanQRToRegisterTicketVC {
    private func setupUI() {
    }
    
    private func setupData() {
        viewModel = ScanQRToRegisterTicketViewModel()
        
        IMTQRCode.permission { [weak self] allow in
            self?.viewModel.start(self, allowCamera: allow)
        }

        IMTQRCode.onScan = { [weak self] value in
            self?.viewModel.updateCode(value, controller: self!)
        }
        
        viewModel.step.bind { [weak self] result in
            self?.lblGuide.attributedText = result?.attributeGuide()
            
        }
        
        viewModel.onComplete = { [weak self] validate, qrCode in
            if let qrCode = qrCode, validate == .success {
                self?.dismiss(animated: true)
                self?.gotoResultRegisterTicket?(qrCode)
            } else {
                self?.viewModel.showWarning(controller: self)
            }
        }
        
        viewModel.onShowTakePhoto.bind { [weak self] show in
            self?.btnScanQR.isHidden = !show!
            
            if (!show! == true) {
                self?.vText.isHidden = true
                self?.imvHandPoint.isHidden = true
            } else {
                self?.vText.isHidden = false
                self?.imvHandPoint.isHidden = false
            }
        }
    }
    
    private func setupViewText() {
        vText.isHidden = true
        imvHandPoint.isHidden = true
    }
    
}
