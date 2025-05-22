//
//  GuideViewModel.swift
//  IMT-iOS
//
//  Created by dev on 10/03/2023.
//

import Foundation
import UIKit

protocol GuideViewModelProtocol {
    var guides: [Guide] { get set }
    var index: ObservableObject<Int> { get set }
    var nextTitle: ObservableObject<(button: String, label: String)> { get set }
    var complete: JVoid { get set }
    
    func next()
    func previous()
    func ignore()
    func checkComplete()
    func scroll(_ scrollView: UICollectionView, page: UIPageControl)
    
    func getNumberItems(_ collection: UICollectionView) -> Int
    func getCell(_ collection: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func getSizeOfCell(_ collection: UICollectionView, indexPath: IndexPath, heightHeader: CGFloat) -> CGSize
    
    func removeObserver()
}

class GuideViewModel {
    
    var index: ObservableObject<Int> = ObservableObject<Int>(0)
    var complete: JVoid = {}
    var nextTitle: ObservableObject<(button: String, label: String)> = ObservableObject<(button: String, label: String)>((button: "", label: ""))
    var guides: [Guide] = [.step1, .step2, .step3]
    var finish: Bool = false
    
    init() {
        self.index.value = 0
        addObserver()
        updateNextTitleIfNeed()
    }
    
    deinit {
        removeObserver()
    }
}

extension GuideViewModel: GuideViewModelProtocol {
    func next() {
        let numItem = guides.count
        if(index.value! + 1 < numItem) {
            index.value! += 1
        } else {
            Utils.setUserDefault(value: KeyUserDefaults.guide.rawValue, forKey: .guide)
            complete()
        }
    }
    
    func previous() {
        if(index.value! - 1 >= 0) {
            index.value! -= 1
            updateNextTitleIfNeed()
        }
    }
    
    @objc func ignore() {
        complete()
    }
    
    func checkComplete() {
        let numItem = guides.count
        if(index.value! >= numItem) {
            complete()
        }
    }
    
    func scroll(_ scrollView: UICollectionView, page: UIPageControl) {
        let x = scrollView.contentOffset.x + scrollView.frame.size.width / 2
        let y = scrollView.contentOffset.y + scrollView.frame.size.height / 2
        let point = CGPoint(x: x, y: y)
        guard let indexPath = scrollView.indexPathForItem(at: point) else { return }
        
        let contentOffset = scrollView.contentOffset.x;
        let maximumOffset = scrollView.contentSize.width - scrollView.frame.size.width;

        let space: Float = 0.0
        let left: Float = Float(String(format: "%.2f", contentOffset)) ?? 0 - space;
        let right: Float = Float(String(format: "%.2f", maximumOffset)) ?? 0;
        
        let numItem = guides.count
        let isEndStep = index.value == numItem - 1
        
        if(left > right - 10.0 && isEndStep) {
            complete();
        } else {
            index.updateNoBind(indexPath.item)
            page.currentPage = indexPath.item
            updateNextTitleIfNeed()
        }
    }
    
    func getNumberItems(_ collection: UICollectionView) -> Int {
        return guides.count
    }
    
    func getCell(_ collection: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: GuideCell.identifier, for: indexPath) as? GuideCell else { return UICollectionViewCell () }
        let index = indexPath.item
        let guide = guides[index]
        cell.setup(guide: guide)
        
        return cell
    }
    
    func getSizeOfCell(_ collection: UICollectionView, indexPath: IndexPath, heightHeader: CGFloat) -> CGSize {
        let spaceHeader: CGFloat = heightHeader + 1
        var ratioMain: CGFloat = Constants.BottomSheetConfigure.ratioMainScreen
        
        if (UIScreen.main.bounds.height <= Constants.hScreenSE1) {
            ratioMain = Constants.BottomSheetConfigure.ratioMainScreenSE1
        } else if (UIScreen.main.bounds.height <= Constants.hScreenSE3) {
            ratioMain = (UIScreen.isZoomed ? Constants.BottomSheetConfigure.ratioMainScreenSE1 : Constants.BottomSheetConfigure.ratioMainScreenSE3)
        }
        
        let hCell = round((UIScreen.main.bounds.height - IMTTabVC.getHeightHeader()) * ratioMain) -  spaceHeader
        let wCell = UIScreen.main.bounds.width
        
        return CGSize(width: wCell, height: hCell)
    }
    
    func removeObserver() {
        Utils.removeObserver(self, name: .hideGuide)
    }
}

extension GuideViewModel {
    private func updateNextTitleIfNeed() {
        guard let index = index.value else { return }
        let numItem = guides.count
        let isEndStep = index == numItem - 1
        let buttonTitle: String = isEndStep ? .guide.complete : .guide.next
        let labelTitle: String = guides[index].title()
        self.nextTitle.value = (button: buttonTitle, label: labelTitle)
    }
    
    private func addObserver() {
        Utils.onObserver(self, selector: #selector(ignore), name: .hideGuide)
    }
}
