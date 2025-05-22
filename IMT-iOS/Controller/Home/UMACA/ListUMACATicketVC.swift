//
//  ListUMACATicketVC.swift
//  IMT-iOS
//
//  Created by dev on 05/10/2023.
//

import UIKit

class ListUMACATicketVC: BaseViewController {
    
    @IBOutlet weak var vContentUMACA: UIView!
    
    @IBOutlet weak var vRightUMACA: UIView!
    @IBOutlet weak var vLeftUMACA: UIView!
    
    @IBOutlet weak var lbCardNumber: UILabel!
    
    @IBOutlet weak var btnConnectUMACA: IMTButton!
    @IBOutlet weak var btnDisconnectUMACA: IMTButton!
    
    public var onGotoUpdateUMACATicket: JVoid?
    public var onGotoRegisterUMACA: JVoid?
    
    private var inputScreen: VotingOnlineFromScreen!
    
    init(_ inputScreen: VotingOnlineFromScreen = .other) {
        super.init(nibName: nil, bundle: nil)
        
        self.inputScreen = inputScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: ListUMACATicketViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
        if(viewModel?.needGetData == true) {
            viewModel?.getData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(viewModel?.needGetData == false) {
            Utils.showProgress()
        }
    }
    
    //MARK: Action
    @IBAction func actionConnectUMACATicket1(_ sender: Any) {
        viewModel?.connect()
    }
    
    @IBAction func actionDisconnectUMACATicket1(_ sender: Any) {
        viewModel?.disconnect()
    }
    
    @IBAction func actionUpdateUMACATicket1(_ sender: Any) {
        if(self.inputScreen == .other) {
            viewModel?.updateUMACATicket(self)
        } else {
            onGotoUpdateUMACATicket?()
        }
    }
    
    override func gotoBack() {
        viewModel?.back(self)
    }

}

extension ListUMACATicketVC {
    private func setupUI(){
        configShadow()
        hiddenControl()
        setupNavigation()
        setRadius(8)
    }
    
    private func setupData(){
        viewModel = ListUMACATicketViewModel()
        
        viewModel?.umacaTicket.bind { [weak self] value in
            guard let data = value else { return }
            var numUMACARegister = 0
            
            if let cardNumber = data.cardNumber, !cardNumber.isEmpty {
                self?.vContentUMACA.isHidden = false
                self?.lbCardNumber.IMTAttributeTitle("Card Number：\(cardNumber)")
                
                let connect = data.umacaFlg == "1"
                self?.btnDisconnectUMACA.isHidden = !connect
                self?.viewModel?.configButtonActive(button: self?.btnConnectUMACA, background: self?.vRightUMACA, isActive: connect, lbCardNumber: self?.lbCardNumber)
                self?.vContentUMACA.isHidden = false
                numUMACARegister += 1
            } else {
                self?.vContentUMACA.isHidden = true
            }
        }
    }
    
    private func hiddenControl() {
        self.vContentUMACA.isHidden = true
    }
    
    private func configShadow() {
        vContentUMACA.setShadow()
    }
    
    private func setRadius(_ radius: CGFloat) {
        vContentUMACA.roundCorners([.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: radius)
        vLeftUMACA.roundCorners([.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: radius)
    }
}

extension ListUMACATicketVC: IMTNavigationController {
    
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.umacaTicket
    }
    
    func navigationBar() -> Bool {
        return true
    }
}
