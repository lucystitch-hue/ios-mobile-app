//
//  TopFavoriteVC.swift
//  IMT-iOS
//
//  Created on 15/03/2024.
//
    

import UIKit

class TopFavoriteVC: BaseViewController {

    @IBOutlet weak var lblTitle: IMTLabel!
    @IBOutlet weak var lblDate: IMTLabel!
    @IBOutlet weak var tbvTop: UITableView!
    @IBOutlet weak var cstHeightTable: NSLayoutConstraint!
    @IBOutlet weak var segmentControlView: UIView!
    
    private lazy var segmentControl: SegmentControl = {
        let segmentControl = SegmentControl.instantiateView()
        segmentControl.distribution = .fill
        segmentControlView.addSameSizeConstaints(subView: segmentControl)
        return segmentControl
    }()
    
    private var viewModel: TopFavoriteViewModelProtocol!
    
    init() {
        super.init(nibName: "TopFavoriteVC", bundle: nil)
        self.viewModel = TopFavoriteViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tableView = object as? UITableView,
           tableView == tbvTop {
            cstHeightTable.constant = tbvTop.contentSize.height
        }
    }
}

//MARK: Private
extension TopFavoriteVC {
    private func setupUI() {
        configTable()
        setupSegmentControl()
        setupDateLabel()
    }
    
    private func setupData() {
        viewModel.items.bind { [weak self]result in
            self?.tbvTop.reloadData()
        }
        
        viewModel.onRegistDate.bind { [weak self] date in
            guard let strDate = date else { return }
            self?.lblDate.text = date
        }
    }
    
    private func configTable() {
        tbvTop.addObserver(self, forKeyPath: "contentSize", context: nil)
        viewModel.registerCell(tbvTop)
    }
    
    private func setupSegmentControl() {
        segmentControl.delegate = self
        segmentControl.removeAllSegments()
        let buttons = viewModel.availableSegment.mapIndex { UIButton(title: $1.text(), tag: $0) }
        segmentControl.items = buttons
        segmentControl.selectedSegmentIndex = viewModel.selectedSegment.rawValue
    }
    
    private func setupDateLabel() {
        self.lblDate.text = viewModel.getDateLabel()
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension TopFavoriteVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numSection(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numCell(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.getCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.getFootter(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.getHeightFootter(tableView, section: section)
    }
}

extension TopFavoriteVC: SegmentControlDelegate {
    func segmentControl(_ segmentControl: SegmentControl, didSelect item: UIButton) {
        if let segment = RoutineHorseSegment(rawValue: item.tag) {
            viewModel.selectedSegment = segment
        }
    }
    
    func segmentControl(_ segmentControl: SegmentControl, shouldSelect item: UIButton) -> Bool {
        return true
    }
}
