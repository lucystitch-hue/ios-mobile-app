
//
//  GuideVC.swift
//  IMT-iOS
//
//  Created by dev on 10/03/2023.
//

import UIKit

class GuideVC: UIViewController {
    @IBOutlet weak var clvStep: UICollectionView!
    @IBOutlet weak var pageStep: UIPageControl!
    @IBOutlet weak var btnNext: IMTButton!
    @IBOutlet weak var lblStepTitle: IMTLabel!
    @IBOutlet weak var vHeader: IMTView!
    @IBOutlet weak var cstHeightHeader: NSLayoutConstraint!
    
    public var onGotoLinkageSubcription: JVoid?
    public var onDismiss:JVoid?
    
    private var viewModel: GuideViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.removeObserver()
    }
    
    //MARK: Action
    @IBAction func actionNext(_ sender: Any) {
        viewModel.next()
    }
}

//MARK: Private
extension GuideVC {
    private func setupUI() {
        configCollection()
        configControlPage()
        configHeader()
    }
    
    private func setupData() {
        viewModel = GuideViewModel()
        
        self.pageStep.numberOfPages = viewModel.guides.count
        
        viewModel.index.bind { [weak self] result in
            guard let index = result else { return }
            
            let indexPath = IndexPath(item: index, section: 0)
            self?.clvStep.isPagingEnabled = false
            self?.clvStep.scrollToItem(at: indexPath, at: .right, animated: true)
            self?.clvStep.isPagingEnabled = true
            
            self?.pageStep.currentPage = index
        }
        
        viewModel.nextTitle.bind { [weak self] result in
            self?.btnNext.setTitle(result?.button, for: .normal)
            self?.lblStepTitle.text = result?.label
        }
        
        viewModel.complete = { [weak self] in
            self?.onDismiss?()
            UserManager.share().hideGuide()
            if(UserManager.share().legalAge()) {
                if(UserManager.share().showLinkageIpat()) {
                    self?.onGotoLinkageSubcription?()
                }
            }
        }
    }
    
    private func configCollection() {
        self.clvStep.register(identifer: GuideCell.identifier)
        self.clvStep.delegate = self
    }
    
    private func configControlPage() {
        pageStep.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }
    }
    
    private func configHeader() {
        let radius = Utils.scaleWithHeight(40.0) / 2.0
        vHeader.roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: radius)
    }
}

extension GuideVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberItems(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.getCell(collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightHeader = cstHeightHeader.constant
        return viewModel.getSizeOfCell(collectionView, indexPath: indexPath, heightHeader: heightHeader)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == clvStep) {
            viewModel.scroll(clvStep, page: pageStep)
        }
    }
}

