//
//  ResultTicketVC.swift
//  IMT-iOS
//
//  Created by dev on 21/04/2023.
//

import UIKit

class ResultTicketVC: BaseViewController  {
    @IBOutlet weak var imvTicket: UIImageView!
    @IBOutlet weak var btnGotoList: IMTButton!
    @IBOutlet weak var lbBettingTicket: IMTLabel!
    @IBOutlet weak var lbBettingTicketCreate: IMTLabel!
    
    public var onGotoListMemorial: JVoid?
    public var onGotoScanQR: JVoid?
    
    private var bundle: [HomeBundleKey: Any]?
    private var viewModel: ResultTicketViewModelProtocol!
    
    init(bundle: [HomeBundleKey: Any]?) {
        super.init(nibName: nil, bundle: nil)
        self.bundle = bundle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utils.showProgress(false)
        
        Utils.mainAsyncAfter {
            Utils.hideProgress()
            self.configShowLabel()
            self.viewModel.enableButton()
        }
    }
    
    @IBAction func actionPreview(_ sender: Any) {
        self.onGotoListMemorial?()
    }
}

extension ResultTicketVC {
    private func setupUI(){
        configHiddenLabel()
    }
    
    private func configHiddenLabel(){
        lbBettingTicket.isHidden = true
        lbBettingTicketCreate.isHidden = true
    }
    
    private func configShowLabel(){
        lbBettingTicket.isHidden = false
        lbBettingTicketCreate.isHidden = false
    }
    

    private func setupData() {
        viewModel = ResultTicketViewModel(bundle: bundle)
        
        viewModel.onGotoWarning = { [weak self] bundle in
            let data = bundle?["data"]
            self?.viewModel.showWarning(self, data: data as? [IListQRModel])
        }
        
        viewModel.onGotoScan = { [weak self] in
            self?.onGotoScanQR?()
        }
        
        viewModel.onEnableButton.bind { [weak self] value in
            guard let value = value else { return }
            let backgroundColor: UIColor = value ? .spanishOrange : .americanSilver
            self?.btnGotoList.backgroundColor = backgroundColor
        }
    }
}

