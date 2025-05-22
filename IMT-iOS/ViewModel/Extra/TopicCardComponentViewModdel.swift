//
//  TopicCardComponentViewModel.swift
//  IMT-iOS
//
//  Created by dev on 06/06/2023.
//

import Foundation
import UIKit

protocol TopicCardComponentViewModelProtocol: CollectionWidgetProtocol {
    func getData() -> [TopicCardModel]
    func getNumberSection(_ collection: UICollectionView) -> Int
    func getHeader(_ collection: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView?
    func getHeaderSize(_ collection: UICollectionView, section: Int) -> CGSize
}

class TopicCardComponentViewModel {
    var selectedItem: (any CaseIterable)? = nil
    var sections: [TopicCardModel]
    private var paddingHorizotal: CGFloat = 20
    private var heightCell: CGFloat = Utils.smallScreen() ? 100 : 97
    private var heightHeaderDefault: CGFloat = 10.0
    
    init(sections: [TopicCardModel], paddingHorizotal: CGFloat? = 20, heightCell: CGFloat?, heightHeader: CGFloat? = 10) {
        self.sections = sections
        
        if let paddingHorizotal = paddingHorizotal {
            self.paddingHorizotal = paddingHorizotal
        }
        
        if let heightCell = heightCell {
            self.heightCell = heightCell
        }
        
        if let heightHeader = heightHeader {
            self.heightHeaderDefault = heightHeader
        }
    }
}

extension TopicCardComponentViewModel: TopicCardComponentViewModelProtocol {
    
    func registerCell(_ collection: UICollectionView) {
        collection.register(identifer: ITopicCardCell.identifier)
        collection.register(CLVHeaderTitle.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CLVHeaderTitle.identifier)
    }
    
    func getNumberSection(_ collection: UICollectionView) -> Int {
        return self.sections.count
    }
    
    func getNumberItems(_ collection: UICollectionView, section: Int) -> Int {
        let item = self.sections[section]
        return item.subItems.count
    }
    
    func getCell(_ collection: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: ITopicCardCell.identifier, for: indexPath) as? ITopicCardCell else { return UICollectionViewCell() }
        let section = self.sections[indexPath.section]
        let subItem = section.subItems[indexPath.item]
        cell.setup(subItem)
        return cell
    }
    
    func getSizeOfCell(_ collection: UICollectionView, indexPath: IndexPath) -> CGSize {
        let item = sections[0] //Follow first section
        let numItemOfRow = item.subItems.count
        let space: Double = 10
        let totalSpace: Double = (Double(numItemOfRow) - 1.0) * space
        var wCell: Double = (Double(collection.bounds.width - totalSpace) / Double(numItemOfRow)) - paddingHorizotal
        wCell.round(.towardZero)
        let hCell: Double = heightCell
        
        return CGSize(width: wCell, height: 108)
    }
    
    func getHeader(_ collection: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? {
        let header = collection.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CLVHeaderTitle.identifier, for: indexPath) as! CLVHeaderTitle
        let item = self.sections[indexPath.section]
        header.setup(subTitle: item.subTitle)
        return header
    }
    
    func getHeaderSize(_ collection: UICollectionView, section: Int) -> CGSize {
        let item = self.sections[section]
        let indexPath = IndexPath(item: 0, section: section)
        let header = collection.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CLVHeaderTitle.identifier, for: indexPath) as! CLVHeaderTitle
        
        if let _ = item.subTitle {
            header.setup(subTitle: item.subTitle)
            return CGSize(width: collection.bounds.width, height: header.getContentHeight())
        } else if(section != 0 && section != sections.count) {
            return CGSize(width: 0, height: heightHeaderDefault)
        } else {
            return .zero
        }
    }
    
    func getData() -> [TopicCardModel] {
        return sections
    }
    
    func minimumLineSpacingForSection(_ collection: UICollectionView, _ section: Int) -> CGFloat {
        return 0.0
    }
}
