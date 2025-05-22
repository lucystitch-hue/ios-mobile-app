//
//  CurrentRaceView.swift
//  IMT-iOS
//
//  Created by dev on 09/03/2023.
//

import UIKit

protocol CurrentRaceViewDelegate {
    func didHeightChange(_ height: Float, view: CurrentRaceView)
    func didTransaction(link: JMLink, view: CurrentRaceView)
    func didTransaction(link: JMLink, didChoiceView view: CurrentRaceView)
}

class CurrentRaceView: UIView {
    
    @IBOutlet var vContent: UIView!
    @IBOutlet weak var clvDate: UICollectionView!
    @IBOutlet weak var clvPlace: UICollectionView!
    @IBOutlet weak var tbvRace: UITableView!
    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var cstHeightCollectionDate: NSLayoutConstraint!
    @IBOutlet weak var cstHeightCollectionPlace: NSLayoutConstraint!
    @IBOutlet weak var cstBottomTableView: NSLayoutConstraint!
    @IBOutlet weak var cstHeightLine: NSLayoutConstraint!
    @IBOutlet weak var cstTopContent: NSLayoutConstraint!
    @IBOutlet weak var cstBottomDate: NSLayoutConstraint!
    
    
    //MARK: Logic Prop
    var viewModel: CurrentRaceViewModelProtocol?
    
    var heightDate: Float = 33.0 {
        didSet {
            self.cstHeightCollectionDate.constant = CGFloat(heightDate)
        }
    }
    
    var heightPlace: Float = 86.0 {
        didSet {
            self.cstHeightCollectionPlace.constant = CGFloat(heightPlace)
        }
    }
    
    var heightLine: Float = 2 {
        didSet {
            self.cstHeightLine.constant = CGFloat(heightLine)
        }
    }
    
    var bottomContent: Float = 42.0 {
        didSet {
            self.cstBottomTableView.constant = CGFloat(bottomContent)
        }
    }
    
    var paddingTopContent: Float = Float(-RacePlaceCell.borderWidth) {
        didSet {
            self.cstTopContent.constant = CGFloat(paddingTopContent)
        }
    }
    
    var paddingBottomDate: Float = Float(-RaceDateCell.borderWidth) {
        didSet {
            self.cstBottomDate.constant = CGFloat(paddingTopContent)
        }
    }
    
    var delegate: CurrentRaceViewDelegate?
    var isCenterPlace: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    public func setupData(data: IMTceData) {
        if(viewModel == nil) {
            configTable()
            configCollection()
            updateHeightView()
            
            viewModel = CurrentRaceViewModel(data)
            
            viewModel?.onBackgroundColor = { [weak self] result in
                self?.tbvRace.backgroundColor = result
            }
            
            viewModel?.onTabColor = { [weak self] (dateColor, placeColor) in
                self?.vLine.backgroundColor = dateColor
            }
            
            viewModel?.raceByDates.bind { [weak self] results in
                guard let indexYear = self?.viewModel?.getCacheIndexDate() else { return }
                self?.viewModel?.updateIndexDate(indexYear)
                self?.clvDate.reloadData()
            }
            
            viewModel?.raceByPlaces.bind { [weak self] results in
                self?.clvPlace.reloadData()
            }
            
            viewModel?.races.bind { [weak self] results in
                self?.tbvRace.reloadData()
            }
            
            viewModel?.onTransaction = { [weak self] result in
                self?.delegate?.didTransaction(link: result, view: self!)
            }
            
            viewModel?.onTransactionWhenDidChoice = { [weak self] result in
                self?.delegate?.didTransaction(link: result, didChoiceView: self!)
            }
            
            tbvRace.addObserver(self, forKeyPath: "contentSize",context: nil)
        } else {
            viewModel?.setup(data: data)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let tableView = object as? UITableView else { return }
        if(tableView == tbvRace) {
            updateHeightView()
        }
    }
}

extension CurrentRaceView {
    private func commonInit() {
        configUI()
    }
    
    private func configUI() {
        configContent()
    }
    
    private func configContent() {
        Bundle.main.loadNibNamed("CurrentRaceView", owner: self, options: nil)
        self.addSubview(vContent)
        Utils.constraintFull(parent: self, child: vContent)
    }
    
    private func configTable() {
        self.tbvRace.dataSource = self
        self.tbvRace.delegate = self
        self.tbvRace.setShadow()
        self.tbvRace.register(identifier: RaceCell.identifier)
    }
    
    private func configCollection() {
        self.clvDate.dataSource = self
        self.clvDate.delegate = self
        self.clvPlace.dataSource = self
        self.clvPlace.delegate = self
        
        self.clvDate.register(identifer: RaceDateCell.identifier)
        self.clvPlace.register(identifer: RacePlaceCell.identifier)
    }
    
    private func updateHeightView() {
        if(viewModel?.races.value?.count != 0) {
            let heightContent: Float = Float(tbvRace.contentSize.height)
            var hSummary: Float = 0
            hSummary = heightDate + heightPlace + heightContent + bottomContent + heightLine + paddingBottomDate + paddingTopContent
            self.delegate?.didHeightChange(hSummary, view: self)
        } else {
            self.delegate?.didHeightChange(0, view: self)
        }
    }
}

extension CurrentRaceView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numCollection(collectionView) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel!.getCollection(collectionView, atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel!.getSizeCollection(collectionView, atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        viewModel!.getMinimumLineSpacing(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel!.getEdges(collectionView, isCenter: isCenterPlace)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel!.didSelectCollection(collectionView, atIndexPath: indexPath)
    }
}

extension CurrentRaceView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numSection(tableView) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel!.getTableCell(tableView, atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel!.getFooterView(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel!.getHeightFooter(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
