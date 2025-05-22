//
//  StakingCLVCell.swift
//  IMT-iOS
//
//  Created by dev on 08/03/2023.
//

import UIKit

class StakingCell: UICollectionViewCell {
    static let identifer = "StakingCell"
    
    @IBOutlet weak var tbvStaking: UITableView!
    var topicsOfSection: [TopicModel]!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    func setup(topicsOfSection: [TopicModel]?) {
        guard let topicsOfSection = topicsOfSection else { return }
        self.topicsOfSection = topicsOfSection
        self.tbvStaking.layoutIfNeeded()
        self.tbvStaking.reloadData()
    }
    
    func getContentHeight() -> Float {
        return Float(tbvStaking.contentSize.height)
    }
}

//MARK: Private
extension StakingCell {
    private func configUI() {
        self.configTableView()
    }
    
    private func configTableView() {
        self.tbvStaking.dataSource = self
        self.tbvStaking.delegate = self
        
        self.tbvStaking.register(identifier: TopicCell.identifier)
    }
}

extension StakingCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicsOfSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicCell.identifier) as? TopicCell else {
            return UITableViewCell() }
        let item = topicsOfSection[indexPath.row];
        cell.setup(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
