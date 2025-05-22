//
//  CollectWidget.swift
//  IMT-iOS
//
//  Created by dev on 24/04/2023.
//

import UIKit

protocol CollectWidgetDelegate {
    func kindOfCollectWidget(_ widget: CollectWidget) -> CollectWidgetStyle
    func collectWidget(_ widget: CollectWidget, heightChange: Float)
    func collectWidget(_ widget: CollectWidget, didSelectAt index: Int)
    func collectWidget(_ widget: CollectWidget, disableWidgetAt index: Int) -> Bool
}

class CollectWidget: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var clvWidget: UICollectionView!
    
    public var delegate: CollectWidgetDelegate?
    private var viewModel: CollectionWidgetProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public func setup() {
        setupData()
        setupUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let collection = object as? UICollectionView else { return }
        if(collection == clvWidget) {
            updateHeightView()
        }
    }
    
    public func reloadData() {
        self.clvWidget.reloadData()
    }
    
    public func selected(_ item: (any CaseIterable)) {
        viewModel.selectedItem = item
        reloadData()
    }
}

//MARK: Private
extension CollectWidget {
    private func commonInit() {
        configContent()
    }
    
    private func setupUI() {
        configCollection()
    }
    
    private func setupData() {
        guard let delegate = delegate else { return }
        viewModel = CollectionWidgetViewModel(style: delegate.kindOfCollectWidget(self))
    }
    
    private func configContent() {
        Bundle.main.loadNibNamed("CollectWidget", owner: self)
        self.addSubview(contentView)
        Utils.constraintFull(parent: self, child: contentView)
        self.contentView.backgroundColor = self.backgroundColor
    }
    
    private func configCollection() {
        clvWidget.dataSource = self
        clvWidget.delegate = self
        
        clvWidget.addObserver(self, forKeyPath: "contentSize",context: nil)
        
        viewModel.registerCell(clvWidget)
    }
    
    private func updateHeightView() {
        if viewModel != nil {
            self.delegate?.collectWidget(self, heightChange: Float(self.clvWidget.contentSize.height))
        } else {
            self.delegate?.collectWidget(self, heightChange: 0)
        }
    }
}

extension CollectWidget: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberItems(collectionView, section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let disable = self.delegate?.collectWidget(self, disableWidgetAt: indexPath.item) ?? false
        return viewModel.getCell(collectionView, indexPath: indexPath, disable: disable)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getSizeOfCell(collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.collectWidget(self, didSelectAt: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumLineSpacingForSection(collectionView, section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
