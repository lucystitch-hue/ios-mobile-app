//
//  ComfirmationSubscriberNumberVC.swift
//  IMT-iOS
//
//  Created by dev on 26/04/2023.
//

import UIKit

class ListVotingOnlineVC: BaseViewController {
    
    @IBOutlet weak var vContentIPat1: UIView!
    @IBOutlet weak var vContentIPat2: UIView!
    
    @IBOutlet weak var vRightIpat1: UIView!
    @IBOutlet weak var vRightIpat2: UIView!
    @IBOutlet weak var vLeftIpat1: UIView!
    @IBOutlet weak var vLeftIpat2: UIView!
    
    @IBOutlet weak var lbIPatId1: UILabel!
    @IBOutlet weak var lbIPatPass1: UILabel!
    @IBOutlet weak var lbIPatPars1: UILabel!
    @IBOutlet weak var lbIPatId2: UILabel!
    @IBOutlet weak var lbIPatPass2: UILabel!
    @IBOutlet weak var lbIPatPars2: UILabel!
    
    @IBOutlet weak var btnConnectIPat1: IMTButton!
    @IBOutlet weak var btnDisconnectIPat1: IMTButton!
    @IBOutlet weak var btnConnectIPat2: IMTButton!
    @IBOutlet weak var btnDisconnectIPat2: IMTButton!
    @IBOutlet weak var btnRegisterIPat2: IMTButton!
    
    public var onGotoUpdateIPat: ((VotingOnlineType) -> Void)?
    public var onGotoRegisterIPat: JVoid?
    
    private var inputScreen: VotingOnlineFromScreen!
    
    init(_ inputScreen: VotingOnlineFromScreen = .other) {
        super.init(nibName: nil, bundle: nil)
        
        self.inputScreen = inputScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: ListVotingOnlineViewModelProtocol?
    
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
    @IBAction func actionConnectIPat1(_ sender: Any) {
        viewModel?.connect(type: .ipatOne)
    }
    
    @IBAction func actionDisconnectIPat1(_ sender: Any) {
        viewModel?.disconnect(type: .ipatOne)
    }
    
    @IBAction func actionUpdateIPat1(_ sender: Any) {
        if(self.inputScreen == .other) {
            viewModel?.updateIPat(self, type: .ipatOne)
        } else {
            onGotoUpdateIPat?(.ipatOne)
        }
    }
    
    @IBAction func actionConnectIpat2(_ sender: Any) {
        viewModel?.connect(type: .ipatTwo)
    }
    
    @IBAction func actionDisconnectIPat2(_ sender: Any) {
        viewModel?.disconnect(type: .ipatTwo)
    }
    
    @IBAction func actionUpdateIPat2(_ sender: Any) {
        if(self.inputScreen == .other) {
            viewModel?.updateIPat(self, type: .ipatTwo)
        } else {
            onGotoUpdateIPat?(.ipatTwo)
        }
    }
    
    @IBAction func actionRegisterIPat2(_ sender: Any) {
        if(self.inputScreen == .other) {
            viewModel?.registerIPat(self)
        } else {
            self.onGotoRegisterIPat?()
        }
    }
    
    override func gotoBack() {
        viewModel?.back(self)
    }
    
}

extension ListVotingOnlineVC {
    private func setupUI(){
        configShadow()
        hiddenControl()
        setupNavigation()
        setRadius(8)
    }
    
    private func setupData(){
        viewModel = ListVotingOnlineViewModel()
        
        viewModel?.ipatData.bind { [weak self] value in
            guard let data = value?.data else { return }
            var numIpatRegister = 0
            
            //TODO: IPAT1
            if let iPatId1 = data.iPatId1?.decrypt(), !iPatId1.isEmpty,
               let iPatPars1 = data.iPatPars1?.decrypt(),
               let ysnFlg1 = data.ysnFlg1 {
                self?.vContentIPat1.isHidden = false
                self?.lbIPatId1.IMTAttributeTitle("Subscriber Number: \(iPatId1)")
                self?.lbIPatPass1.IMTAttributeTitle("PIN Code: \(data.iPatPass1?.security() ?? "")")
                self?.lbIPatPars1.IMTAttributeTitle("P-ARS Number: \(iPatPars1)")

                
                let connect = ysnFlg1 == "1"
                self?.btnDisconnectIPat1.isHidden = !connect
                self?.btnConnectIPat2.isHidden = connect
                self?.viewModel?.configButtonActive(button: self?.btnConnectIPat1, background: self?.vRightIpat1, isActive: connect, lbIPatId: self?.lbIPatId1, lbIPatPass: self?.lbIPatPass1, lbIPatPars: self?.lbIPatPars1)
                self?.vContentIPat1.isHidden = false
                numIpatRegister += 1
            } else {
                self?.vContentIPat1.isHidden = true
                self?.btnConnectIPat2.isHidden = false
            }
            
            //TODO: IPAT2
            if let iPatId2 = data.iPatId2?.decrypt(), !iPatId2.isEmpty,
               let iPatPars2 = data.iPatPars2?.decrypt(),
               let ysnFlg2 = data.ysnFlg2 {
                self?.lbIPatId2.IMTAttributeTitle("Subscriber Number: \(iPatId2)")
                self?.lbIPatPass2.IMTAttributeTitle("PIN Code: \(data.iPatPass2?.security() ?? "")")
                self?.lbIPatPars2.IMTAttributeTitle("P-ARS Number: \(iPatPars2)")

                
                self?.vContentIPat2.isHidden = false
                let connect = ysnFlg2 == "1"
                self?.btnDisconnectIPat2.isHidden = !connect
                self?.btnConnectIPat1.isHidden = connect
                self?.viewModel?.configButtonActive(button: self?.btnConnectIPat2, background: self?.vRightIpat2, isActive: connect, lbIPatId: self?.lbIPatId2, lbIPatPass: self?.lbIPatPass2, lbIPatPars: self?.lbIPatPars2)
                
                self?.vContentIPat2.isHidden = false
                self?.btnRegisterIPat2.isHidden = true
                numIpatRegister += 1
            } else {
                self?.vContentIPat2.isHidden = true
                self?.btnConnectIPat1.isHidden = false
            }
            
            self?.btnRegisterIPat2.isHidden = numIpatRegister == 2
        }
    }
    
    private func hiddenControl() {
        self.btnRegisterIPat2.isHidden = true
        self.vContentIPat1.isHidden = true
        self.vContentIPat2.isHidden = true
    }
    
    private func configShadow() {
        vContentIPat1.setShadow()
        vContentIPat2.setShadow()
    }
    
    private func setRadius(_ radius: CGFloat) {
        vContentIPat1.roundCorners([.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: radius)
        vContentIPat2.roundCorners([.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: radius)
        vLeftIpat1.roundCorners([.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: radius)
        vLeftIpat2.roundCorners([.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: radius)
    }
}

extension ListVotingOnlineVC: IMTNavigationController {
    
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.subcriberNumber
    }
    
    func navigationBar() -> Bool {
        return true
    }
}


