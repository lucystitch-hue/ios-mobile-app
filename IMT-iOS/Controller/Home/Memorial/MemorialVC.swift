//
//  MemorialVC.swift
//  IMT-iOS
//
//  Created by dev on 13/03/2023.
//

import UIKit

class MemorialVC: BaseViewController {
    
    @IBOutlet weak var lbDescribe: IMTLabel!
    
    public var onGotoListMemorial: JVoid?
    public var onGotoResultRegisterTicket: ((_ qrInfo: RegisterQRModel) -> Void)?
    
    private var viewModel: MemorialViewModelProtocol!
    
    init(bundle: [HomeBundleKey: Any]? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = MemorialViewModel(bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    //MARK: Action
    @IBAction func actionRegister(_ sender: Any) {
        viewModel.resgister()
    }
    
    @IBAction func actionRefer(_ sender: Any) {
        self.onGotoListMemorial?()
    }
}

//MARK: Private
extension MemorialVC {
    private func setupUI() {
       
    }
    
    private func setupData() {
        viewModel.onGotoResultRegisterTicket = { [weak self] qrInfo in
            self?.onGotoResultRegisterTicket?(qrInfo)
        }
        
        viewModel.onGotoScanQR.bind { [weak self] scan in
            if(scan == true) {
                self?.actionRegister("")
            }
        }
        
//        viewModel.onAttribute.bind { [weak self] attribute in
//            self?.lbDescribe.attributedText = attribute
//        }
        
        viewModel.onGotoWarning = { [weak self] bundle in
            let data = bundle?["data"]
            self?.viewModel.showWarning(self, data: data as? [IListQRModel])
        }
        
        viewModel.onGotoScan = { [weak self] in
            self?.viewModel.gotoScanQRToRegisterTicket(self)
        }
        
    }
    
}
