//
//  CollectionWidgetViewModel.swift
//  IMT-iOS
//
//  Created by dev on 24/04/2023.
//

import Foundation
import UIKit

enum CollectWidgetStyle {
    case menu
    case recommendedFunctionsMenu
    case service
    case horseRaceInfoLink
    case abbreviations(_ small: Bool = false)
}

protocol CollectionWidgetProtocol {
    
    var selectedItem: (any CaseIterable)? { get set }
    
    func registerCell(_ collection: UICollectionView)
    func getNumberItems(_ collection: UICollectionView, section: Int) -> Int
    func getCell(_ collection: UICollectionView, indexPath: IndexPath, disable: Bool) -> UICollectionViewCell
    func getCell(_ collection: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func getSizeOfCell(_ collection: UICollectionView, indexPath: IndexPath) -> CGSize
    func minimumLineSpacingForSection(_ collection: UICollectionView,_ section: Int) -> CGFloat
}

extension CollectionWidgetProtocol {
    func getCell(_ collection: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func getCell(_ collection: UICollectionView, indexPath: IndexPath, disable: Bool) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

class CollectionWidgetViewModel {
    private var style: CollectWidgetStyle!
    private var data: [any CaseIterable]!
    var selectedItem: (any CaseIterable)? = nil
    
    init(style: CollectWidgetStyle!) {
        self.style = style
        self.data = getData(style)
    }
    
    private func getData(_ style: CollectWidgetStyle) -> [any CaseIterable] {
        switch style {
        case .menu:
            return MenuWidget.allCases
        case .service:
            return ServiceWidget.allCases
        case .recommendedFunctionsMenu:
            return RecommendedFunctionsMenuWidget.allCases
        case .horseRaceInfoLink:
            return HorseRaceInfoLinkWidget.allCases
        case .abbreviations:
            return Abbreviations.allCases
        }
    }
}

extension CollectionWidgetViewModel: CollectionWidgetProtocol {
    
    func registerCell(_ collection: UICollectionView) {
        switch style {
        case .menu, .horseRaceInfoLink, .recommendedFunctionsMenu:
            collection.register(identifer: RectangleCell.identifier)
            break
        case .service:
            collection.register(identifer: CircleCell.identifier)
            break
        case .abbreviations:
            collection.register(identifer: AbbreviationCollectionViewCell.identifier)
            break
        default:
            break
        }
    }
    
    func getNumberItems(_ collection: UICollectionView, section: Int) -> Int {
        return data.count
    }
    
    func getCell(_ collection: UICollectionView, indexPath: IndexPath, disable: Bool = false) -> UICollectionViewCell {
        switch style {
        case .menu, .horseRaceInfoLink, .recommendedFunctionsMenu:
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: RectangleCell.identifier, for: indexPath) as? RectangleCell else { return UICollectionViewCell() }
            let item = data[indexPath.item] as? (any BaseCollectionWidget)
            cell.setup(item?.image())
            
            return cell
        case .service:
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: CircleCell.identifier, for: indexPath) as? CircleCell else { return UICollectionViewCell() }
            let item = data[indexPath.item] as? ServiceWidget
            let image = disable ? item?.disableImage() : item?.image()
            cell.setup(image, title: item?.rawValue)
            
            return cell
        case .abbreviations(let small):
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: AbbreviationCollectionViewCell.identifier, for: indexPath) as? AbbreviationCollectionViewCell else { return UICollectionViewCell() }
            let item = data[indexPath.item] as? Abbreviations
            let isSelected = item == (selectedItem as? Abbreviations)
            cell.setup(title: item?.rawValue, small: small, selected: isSelected)
            return cell
        case .none:
            return UICollectionViewCell()
        }
    }
    
    func getSizeOfCell(_ collection: UICollectionView, indexPath: IndexPath) -> CGSize {
        var hCell: CGFloat = Utils.scaleWithHeight(100);
        var wCell: CGFloat = UIScreen.main.bounds.size.width - 28.0
        let space: CGFloat = 5
        
        switch style {
        case .menu, .horseRaceInfoLink:
            hCell = Constants.HeightRectangeCell.menu
            wCell = (wCell / 2.0).rounded(.down) - 1
            break
        case .recommendedFunctionsMenu:
            wCell = (wCell / 2.0).rounded(.down) - 1 - space
            hCell = wCell * (70.0 / 171.0)
            
            break
        case .service:
            hCell = Constants.HeightCircleCell.service
            wCell = wCell / 3 - space * 2
            break
        case .abbreviations(let small):
            let col = small ? 6.0 : 4.0
            let spacing = small ? 5.0 : 15.0
            wCell = (UIScreen.main.bounds.size.width * 0.9 / col).rounded(.down) - spacing
            hCell = small ? (wCell * 40 / 57) : wCell
            break
        default:
            break
        }
        
        return CGSize(width: wCell, height: hCell)
    }
    
    func minimumLineSpacingForSection(_ collection: UICollectionView,_ section: Int) -> CGFloat {
        switch style {
        case .abbreviations(let small):
            return small ? 5.0 : 10.0
        default:
            return 0.0
        }
    }
}
