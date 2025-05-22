
//
//  ResultUpdateEmailFailureVC.swift
//  IMT-iOS
//
//  Created by dev on 31/08/2023.
//

import UIKit

class ResultUpdateEmailFailureVC: BaseViewController {

    @IBOutlet weak var lblMessage: IMTLabel!
    
    public var onDismiss: JVoid?
    
    private var viewModel: ResultUpdateEmailFailureProtocol!
    private var message: String!
    
    init(message: String) {
        super.init(nibName: nil, bundle: nil)
        self.message = message
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        onDismiss?()
    }
}

//MARK: Private
extension ResultUpdateEmailFailureVC {
    private func setupUI() {
        setupNavigation()
    }
    
    private func setupData() {
        viewModel = ResultUpdateEmailFailureViewModel()
    }
}

extension ResultUpdateEmailFailureVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return String.TitleScreen.resultUpdateEmailFailure
    }
    
    func navigationBar() -> Bool {
        return true
    }
}
