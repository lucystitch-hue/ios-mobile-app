//
//  TopicCardComponent.swift
//  IMT-iOS
//
//  Created by dev on 06/06/2023.
//

import Foundation
import UIKit

protocol TopicCardComponentDelegate {
    func didSelectTopicCard(_ component: TopicCardComponent, atIndex indexPath: IndexPath, object: Any)
    
    func topicCard(_ component: TopicCardComponent, insetForSectionAt section: Int, object: Any) -> UIEdgeInsets
    func heightTopicCard(_ component: TopicCardComponent) -> CGFloat
    func paddingHorizotalTopicCard(_ component: TopicCardComponent) -> CGFloat
    func heightHeader(_ component: TopicCardComponent) -> CGFloat
}

class TopicCardComponent: UIView {
    
    @IBOutlet private var vContent: UIView!
    @IBOutlet weak var svContainer: UIStackView!
    @IBOutlet private weak var vHeader: UIView!
    @IBOutlet private weak var clvContent: UICollectionView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var cstHeightHeader: NSLayoutConstraint!
    
    public var delegate: TopicCardComponentDelegate?
    
    public var onContentHeight: JDouble?
    
    public var heightHeader: CGFloat {
        get {
            return cstHeightHeader.constant
        }
        
        set {
            self.cstHeightHeader.constant = newValue
        }
    }
    
    var radius: CGFloat = 10 {
        didSet {
            setRadius(radius)
        }
    }
    
    private var viewModel: TopicCardComponentViewModelProtocol!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let collection = object as? UICollectionView else { return }
        if(collection == clvContent) {
            updateContentHeight()
        }
    }
    
    public func setup(title: String, theme: UIColor, data: [TopicCardModel]) {
        setupData(data: data)
        setupUI(title: title, theme: theme)
    }
}

//MARK: Private
extension TopicCardComponent {
    private func commonInit() {
        
    }
    
    private func setupUI(title: String, theme: UIColor) {
        configContentView()
        configTitle(title)
        configHeader(theme)
        configCollection()
    }
    
    private func setupData(data: [TopicCardModel]) {
        let paddingHorizotal = self.delegate?.paddingHorizotalTopicCard(self)
        let height = self.delegate?.heightTopicCard(self)
        let heightHeader = self.delegate?.heightHeader(self)
        
        viewModel = TopicCardComponentViewModel(sections: data, paddingHorizotal: paddingHorizotal, heightCell: height, heightHeader: heightHeader)
    }
    
    private func configContentView() {
        Bundle.main.loadNibNamed("TopicCardComponent", owner: self, options: nil)
        self.addSubview(vContent)
        
        Utils.constraintFull(parent: self, child: vContent)
        setRadius(radius)
    }
    
    private func configTitle(_ value: String) {
        self.lblTitle.text = value
    }
    
    private func configHeader(_ color: UIColor) {
        self.vHeader.backgroundColor = color
    }
    
    private func configCollection() {
        clvContent.dataSource = self
        clvContent.delegate = self
        
        viewModel.registerCell(clvContent)
        clvContent.addObserver(self, forKeyPath: "contentSize", context: nil)
    }
    
    private func updateContentHeight() {
        let height = heightHeader + svContainer.spacing + clvContent.contentSize.height
        self.onContentHeight?(height)
    }
    
    private func setRadius(_ radius: CGFloat) {
        self.cornerRadius(radius: radius)
        vContent.cornerRadius(radius: radius)
        vHeader.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: radius)
        clvContent.roundCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: radius)
    }
}

extension TopicCardComponent: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.getNumberSection(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberItems(collectionView, section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.getCell(collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getSizeOfCell(collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return viewModel.getHeader(collectionView, indexPath: indexPath)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.getHeaderSize(collectionView, section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sections = viewModel.getData()
        
        self.delegate?.didSelectTopicCard(self, atIndex: indexPath, object: sections)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sections = viewModel.getData()
        return self.delegate?.topicCard(self, insetForSectionAt: section, object: sections) ?? .zero
    }
}
