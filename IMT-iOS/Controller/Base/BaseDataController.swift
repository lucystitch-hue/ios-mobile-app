//
//  BaseViewModelController.swift
//  IMT-iOS
//
//  Created by dev on 07/03/2023.
//

import UIKit

class BaseDataController<VM: ViewModelProtocol>: BaseViewController {
    
    var viewModel: VM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        setupData()
    }
    
    //TODO: Implement inheirt class. Use config user interface
    func setupUI() {
        
    }
    
    //TODO: Implement inheirt class. Use config data
    func setupData() {
        
    }
    
    //TODO: Implement inheirt class. Use config event
    func setupEvent() {
        
    }
}
