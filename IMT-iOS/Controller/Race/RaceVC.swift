//
//  RaceVC.swift
//  IMT-iOS
//
//  Created by dev on 24/04/2023.
//

import UIKit

class RaceVC: IMTContentActionVC<RaceViewModel> {
    
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var stvContentView: UIStackView!
    @IBOutlet weak var stvMainContent: UIStackView!
    @IBOutlet weak var tbvTraniningRace: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.onHiddenBack(false)
        viewModel.loadContent(self, type: .main)
        viewModel.refreshData()
        Utils.logActionClick(.raceTab)
    }
    
    override func viewContentWillAppear(_ animated: Bool) {
        super.viewContentWillAppear(animated)
        viewWillAppear(animated)
    }
    
    override func setupUI() {
        super.setupUI()
        configTable()
    }
    
    override func setupData() {
        viewModel = RaceViewModel(contentView: vContent, mainView: stvMainContent, homeContentView: vHomeContent)
        
        viewModel.onTransactionRaceYoutube = { [weak self] path in
            self?.transition(path)
        }
    }
    
    override func back() {
        viewModel.back(self)
    }
    
    override func onSwipe(x: CGFloat, alpha: CGFloat, finish: Bool = false) {
        viewModel.swipe(self, x: x, alpha: alpha, finish: finish)
    }
    
    override func getSwipingRatio() -> CGFloat {
        return viewModel.getSwipingRatio()
    }
    
    override func gotoVoteOnline() {
        viewModel.loadContent(self, type: .subcriber)
    }
    
    override func getNumberRemainPage() -> Int {
        return viewModel.getNumberRemainPage()
    }
}

//MARK: Private
extension RaceVC {
    private func configTable() {
        self.tbvTraniningRace.dataSource = self;
        self.tbvTraniningRace.delegate = self;
        self.tbvTraniningRace.register(identifier: TrainingRaceCell.identifier)
    }
}

extension RaceVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberSections(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.getCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.getViewHeaderSection(tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return viewModel.didChoice(controller: self, tableView: tableView, didChoiceRowAt: indexPath)
    }
}


