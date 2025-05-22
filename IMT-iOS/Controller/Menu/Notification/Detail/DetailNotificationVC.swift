//
//  DetailNotificationVC.swift
//  IMT-iOS
//
//  Created by dev on 20/06/2023.
//

import UIKit

class DetailNotificationVC: BaseViewController {
    
    @IBOutlet weak var lbTitle: IMTLabel!
    @IBOutlet weak var lbDateTime: IMTLabel!
    @IBOutlet weak var imvClock: UIImageView!
    @IBOutlet weak var tvMessage: UITextView!
    
    private var viewModel: DetailNotificationViewModelProtocol!
    public var bundle: [NotificationBundleKey: Any]?
    public var onTransition: JString?
    public var onViewDidAppear: JVoid?
    
    init(bundle: [NotificationBundleKey: Any]?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = DetailNotificationViewModel(bundle: bundle)
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
        viewModel.callAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewDidAppear?()
    }
}

extension DetailNotificationVC {
    private func setupUI() {
        configImg()
        configTextView()
    }
    
    private func setupData() {
        viewModel.detailDataModel.bind { [weak self] result in
            dump(result)
            guard let detail =  result?.first else { return }
            self?.lbTitle.text = detail.title
            self?.lbDateTime.attributedText = detail.sendDate?.attributeNotificationDateHour()
            self?.imvClock.isHidden = false
            self?.tvMessage.attributedText = self?.viewModel.getMessageAttribute()
        }
    }
    
    private func configImg(){
        imvClock.isHidden = true
    }
    
    private func configTextView() {
        tvMessage.isEditable = false
        tvMessage.delegate = self
    }
    
}

extension DetailNotificationVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let url = URL.absoluteString.toValidURL()
        self.onTransition?(url)
        return false
    }
}
