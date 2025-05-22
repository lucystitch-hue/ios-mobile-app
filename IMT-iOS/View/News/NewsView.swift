//
//  RaceView.swift
//  IMT-iOS
//
//  Created by dev on 14/03/2023.
//

import UIKit

protocol NewsViewDelegate {
    func didHeightChange(_ height: Float, view: NewsView)
    func didChoiceAllNew(_ view: NewsView)
    func didChoiceNewAt(_ index: Int, view: NewsView)
}

class NewsView: UIView {
    
    @IBOutlet var vContent: UIView!
    @IBOutlet weak var tbvNews: UITableView!
    @IBOutlet weak var cstButtonTop: NSLayoutConstraint!
    @IBOutlet weak var cstButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var cstBottomHeight: NSLayoutConstraint!
    
    public var buttonTop: CGFloat = 20.0 {
        didSet {
            self.cstButtonTop.constant = buttonTop
        }
    }
    
    public var buttonBottom: CGFloat = 1.0 {
        didSet {
            self.cstButtonBottom.constant = buttonBottom
        }
    }
    
    public var buttonHeight: CGFloat = 34.0 {
        didSet {
            self.cstBottomHeight.constant = buttonHeight
        }
    }
    
    let defaultButtonTop: CGFloat = 20.0
    let defaultButtonHeight: CGFloat = 34
    let defaultButtonBottom: CGFloat = 1.0
    
    public var delegate: NewsViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private var viewModel: NewsViewModelProtocol?
    
    public func setup(_ items: [NewModel]) {
        
        viewModel = NewsViewModel(news: items)
        
        viewModel?.news.bind { [weak self] results in
            self?.tbvNews.reloadData()
        }
        
        tbvNews.addObserver(self, forKeyPath: "contentSize",context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let tableView = object as? UITableView else { return }
        if(tableView == tbvNews) {
            updateHeightView()
        }
    }
    
    @IBAction func actionAllNew(_ sender: Any) {
        delegate.didChoiceAllNew(self)
    }
}

//MARK: Private
extension NewsView {
    
    private func commonInit() {
        configContent()
        configTable()
        updateHeightView()
    }
    
    private func configContent() {
        Bundle.main.loadNibNamed("NewsView", owner: self, options: nil)
        self.addSubview(vContent)
        Utils.constraintFull(parent: self, child: vContent)
    }
    
    private func configTable() {
        self.tbvNews.dataSource = self
        self.tbvNews.delegate = self
        self.tbvNews.estimatedRowHeight = 80.0
        self.tbvNews.rowHeight = UITableView.automaticDimension
        self.tbvNews.register(identifier: NewsCell.identifier)
    }
    
    private func updateHeightView() {
        var hSummary: Float = 0.0
        
        if let viewModel = viewModel, let count = viewModel.news.value?.count, count > 0 {
            self.buttonTop = defaultButtonTop;
            self.buttonHeight = defaultButtonHeight;
            self.buttonBottom = defaultButtonBottom;
            
            hSummary = Float(self.tbvNews.contentSize.height + buttonTop + buttonHeight + buttonBottom)
        } else {
            self.buttonTop = 0.0;
            
            hSummary = Float(buttonHeight + buttonBottom)
        }
        
        self.delegate?.didHeightChange(hSummary, view: self)
    }
}

extension NewsView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.news.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier) as? NewsCell else { return UITableViewCell() }
        let item = viewModel?.news.value?[indexPath.section]
        cell.setup(item: item)
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return FootterDotLine()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.HeightConfigure.smallFooterLine
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.didChoiceNewAt(indexPath.section, view: self)
    }
}
