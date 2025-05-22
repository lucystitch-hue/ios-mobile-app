//
//  PreviewTicketVC.swift
//  IMT-iOS
//
//  Created by dev on 16/03/2023.
//

import UIKit
import FacebookShare

class PreviewTicketVC: BaseViewController, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var btnGrade: UIButton!
    @IBOutlet weak var lbName: IMTLabel!
    @IBOutlet weak var lbDateTime: IMTLabel!
    @IBOutlet weak var imvTicket: UIImageView!
    @IBOutlet weak var lblPage: IMTLabel!
    
    private var viewModel: PreviewTicketViewModelProtocol!
    
    private var bundle: [HomeBundleKey: Any]?
    private var documentInteractionController = UIDocumentInteractionController()
    
    public var onDissmiss: JVoid?
    
    init(bundle: [HomeBundleKey: Any]?) {
        super.init(nibName: nil, bundle: nil)
        self.bundle = bundle;
    }
    
    //MARK: Constructor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        setupData()
    }
    
    @IBAction func actionClickInstagram(_ sender: Any) {
        viewModel.share(self, image: imvTicket.image, type: .instagram)
    }
    
    @IBAction func actionClickFacebook(_ sender: Any) {
        viewModel.share(self, image: imvTicket.image, type: .facebook)
    }
    
    @IBAction func actionClickTwiter(_ sender: Any) {
        viewModel.share(self, image: imvTicket.image, type: .twitter)
    }
    
    @IBAction func actionLine(_ sender: Any) {
        viewModel.share(self, image: imvTicket.image, type: .line)
    }
    
    @IBAction func actionSavePhoto(_ sender: Any) {
        viewModel.saveImageToPhone(imvTicket)
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        viewModel.remove(self)
    }
    
    @IBAction func actionPrevious(_ sender: Any) {
        viewModel.previous()
    }
    
    @IBAction func actionNext(_ sender: Any) {
        viewModel.next()
    }
    
}

//MARK: Private
extension PreviewTicketVC {
    
    private func setupUI() {
        addBorderImage()
    }
    
    private func setupData() {
        viewModel = PreviewTicketViewModel(bundle: bundle, lbDateTime: lbDateTime, lbName: lbName, btnGrade: btnGrade)
        
        viewModel.onUpdateTicket.bind { [weak self] data in
            guard let data = data else { return }
            self?.imvTicket.image = data.image?.convertBase64StringToImage()
            self?.lbDateTime.attributedText = self?.viewModel.attributeDate(data.regDateToString())
        }
        
        viewModel.onUpdateControl.bind { [weak self] object in
            guard let object = object else { return }
            self?.lbName.text = object.name.trim()
            self?.lblPage.text = self?.viewModel.getTitlePage()
            
            let gradeHidden = object.grade.isEmpty
            self?.btnGrade.isHidden = gradeHidden
            self?.btnGrade.setTitle(object.grade, for: .normal)
            self?.btnGrade.backgroundColor = GradeName(rawValue: object.grade)?.colorRace()
        }

        viewModel.onSavePhotoSuccess.bind{[weak self] object in
            if (object!) {
                DispatchQueue.main.async {
                    self?.showToastBottom(.ShowToastString.toastSaveImage)
                }
            }
        }
    }
    
    private func addBorderImage(){
        imvTicket.layer.masksToBounds = true
        imvTicket.layer.borderWidth = 1
        imvTicket.layer.borderColor = UIColor.black.cgColor
    }
    
}

extension PreviewTicketVC : SharingDelegate {
    func sharer(_ sharer: FBSDKShareKit.Sharing, didCompleteWithResults results: [String : Any]) {
        print("didCompleteWit",results)
    }
    
    func sharer(_ sharer: FBSDKShareKit.Sharing, didFailWithError error: Error) {
        print("didFail")
    }
    
    func sharerDidCancel(_ sharer: FBSDKShareKit.Sharing) {
        print("sharerDid")
    }
    
}
