//
//  TopicView.swift
//  IMT-iOS
//
//  Created by dev on 08/03/2023.
//

import UIKit

protocol TopicViewDelegate {
    func didHeightChange(_ height: Float, view: TopicView)
    func didChoiceTopic(view: TopicView)
}

class TopicView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var clvTopic: UICollectionView!
    @IBOutlet weak var vContainer: UIStackView!
    @IBOutlet weak var vHeader: UIView!
    @IBOutlet weak var cstHeightHeader: NSLayoutConstraint!
    @IBOutlet weak var cstTopCollectionView: NSLayoutConstraint!
    @IBOutlet weak var cstBottomCollectionView: NSLayoutConstraint!
    @IBOutlet weak var btnTitle: UIButton!
    
    var heightHeader: Float = 32.0 {
        didSet {
            self.cstHeightHeader.constant = CGFloat(heightHeader)
        }
    }
    
    var paddingVertical: Float = 15.0 {
        didSet {
            self.cstTopCollectionView.constant = CGFloat(paddingVertical)
            self.cstBottomCollectionView.constant = CGFloat(paddingVertical)
        }
    }
    
    var radius: CGFloat = 12 {
        didSet {
            setRadius(radius)
        }
    }
    
    var visibleOfNumber: Bool = false
    
    var title: String {
        get {
            return btnTitle.titleLabel?.text ?? ""
        }
        
        set {
            btnTitle.setTitle(newValue, for: .normal)
            btnTitle.titleLabel?.font = UIFont.appFontW7Size(18)
        }
    }

    //Logic properties
    var topics: [TopicModel] = [] {
        didSet {
            if(!topics.isEmpty) {
                self.flagNeedReloadData = true
                didDataChange(topics)
            }
        }
    }
    
    var delegate: TopicViewDelegate?
    private var viewModel: TopicViewModelProtocol?
    private var flagFirstChangeHeight = true
    private var flagNeedReloadData = true
    
    //MARK: Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: Action
    @IBAction func actionNext(_ sender: Any) {
        viewModel?.next()
    }
    
    @IBAction func actionPrevious(_ sender: Any) {
        viewModel?.previous()
    }
    
    @IBAction func actionTopic(_ sender: Any) {
        self.delegate?.didChoiceTopic(view: self)
    }
}

//MARK: Private
extension TopicView {
    private func commonInit() {
        
        self.configUI()
        self.configData()
    }
    
    private func configUI() {
        configContentView()
        configCollection()
    }
    
    private func configData() {
        self.delegate?.didHeightChange(heightHeader, view: self)
    }
    
    private func didDataChange(_ data: [TopicModel]) {
        viewModel = TopicViewModel(data: data)
        
        viewModel?.dataOfSection.bind { [weak self] items in
            guard let viewModel = self?.viewModel else { return }
            
            if(items?.count != 0 && viewModel.bindingIndex && !viewModel.isFirstLoad) {
                self?.clvTopic.isPagingEnabled = false
                self?.clvTopic.scrollToItem(at: IndexPath(item: viewModel.index, section: 0), at: .right, animated: true)
                self?.clvTopic.isPagingEnabled = true
            }
            
            //Caculate number of item is visbile
            var numVisible = Constants.NumItemConfigure.topic
            if(self?.visibleOfNumber == true) {
                numVisible = items!.count < Constants.NumItemConfigure.topic ? items!.count : Constants.NumItemConfigure.topic
            }
            
            if(self?.flagFirstChangeHeight == true) {
                let height = viewModel.caculateHeight(heightHeader: self?.heightHeader, paddingVertical: self?.paddingVertical, numVisible: numVisible, heightContent: nil)
                self?.delegate?.didHeightChange(height, view: self!)
                
                self?.flagFirstChangeHeight = false
            }
            
//            self?.clvTopic.layoutIfNeeded()
            self?.clvTopic.reloadData()
        }
    }
    
    private func configContentView() {
        Bundle.main.loadNibNamed("TopicView", owner: self, options: nil)
        self.addSubview(contentView)
        
        Utils.constraintFull(parent: self, child: contentView)
        setRadius(radius)
    }
    
    private func configCollection() {
        self.clvTopic.dataSource = self;
        self.clvTopic.delegate = self;
        self.clvTopic.register(identifer: StakingCell.identifer)
    }
    
    private func setRadius(_ radius: CGFloat) {
        self.cornerRadius(radius: radius)
        contentView.cornerRadius(radius: radius)
        vHeader.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: radius)
        clvTopic.roundCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: radius)
    }
}

extension TopicView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getNumberPage() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StakingCell.identifer, for: indexPath) as? StakingCell else { return  UICollectionViewCell() }
        cell.setup(topicsOfSection: viewModel?.dataOfSection.value)
        let contentHeight = cell.getContentHeight() //If use, It will flickering
        
        let items = viewModel?.dataOfSection.value
        var numVisible = Constants.NumItemConfigure.topic
        if(self.visibleOfNumber == true) {
            numVisible = items!.count < Constants.NumItemConfigure.topic ? items!.count : Constants.NumItemConfigure.topic
        }
        
        let height = (viewModel?.caculateHeight(heightHeader: self.heightHeader, paddingVertical: self.paddingVertical, numVisible: numVisible, heightContent: contentHeight)) ?? 0
        self.delegate?.didHeightChange(height, view: self)
        
//        if(viewModel?.getNumberPage() == indexPath.section + 1 && flagNeedReloadData) {
            self.clvTopic.reloadData()
//            self.flagNeedReloadData = false
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        let width = collectionView.bounds.size.width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == clvTopic) {
            let x = scrollView.contentOffset.x + scrollView.frame.size.width / 2
            let y = scrollView.contentOffset.y + scrollView.frame.size.height / 2
            let point = CGPoint(x: x, y: y)
            guard let indexPath = clvTopic.indexPathForItem(at: point) else { return }
            
            viewModel?.setIndexNoBind(index: indexPath.row)
        }
    }
}
