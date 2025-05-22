//
//  TopFavoriteViewModel.swift
//  IMT-iOS
//
//  Created on 15/03/2024.
//
    

import Foundation
import UIKit

protocol TopFavoriteViewModelProtocol: TableWidgetProtocol {
    var availableSegment: [RoutineHorseSegment] { get set }
    var items: ObservableObject<[OshiUmaRanking]> { get set }
    var selectedSegment: RoutineHorseSegment { get set }
    var onRegistDate: ObservableObject<String> { get set }
    
    func getDateLabel(_ date: Date) -> String
}

extension TopFavoriteViewModelProtocol {
    func getDateLabel(_ date: Date = Date()) -> String {
        return "\(date.toString(format: .IMTMMSignaldd)) Current"

    }
}

class TopFavoriteViewModel: BaseViewModel, TopFavoriteViewModelProtocol {
    var onRegistDate: ObservableObject<String> = ObservableObject<String>("")
    var availableSegment: [RoutineHorseSegment] =  RoutineHorseSegment.allCases
    var items: ObservableObject<[OshiUmaRanking]> = ObservableObject<[OshiUmaRanking]>([])
    var selectedSegment: RoutineHorseSegment = .cumulative {
        didSet {
            self.fetch()
        }
    }
    
    override init() {
        super.init()
        self.getRegistDate { [weak self] date in
            self?.onRegistDate.value = date
            self?.fetch()
        }
    }
    
    func numSection(_ tableView: UITableView) -> Int {
        guard let count = self.items.value?.count else { return 0 }
        return count
    }
    
    func numCell(_ tableView: UITableView, section: Int) -> Int {
        return 1
    }
    
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ITopFavoriteCell.identifier, for: indexPath) as? ITopFavoriteCell else { return UITableViewCell() }
        let index = indexPath.section
        let item = self.items.value?[index]
        cell.setup(item)
        
        return cell
    }
    
    func getFootter(_ tableView: UITableView, section: Int) -> UIView? {
        let vFootter = FooterLine(paddingLeft: 0.0)
        return vFootter
    }
    
    func getHeightFootter(_ tableView: UITableView, section: Int) -> CGFloat {
        return Constants.HeightConfigure.smallFooterLine
    }
    
    func registerCell(_ tableView: UITableView) {
        tableView.register(identifier: ITopFavoriteCell.identifier)
    }
}

//MARK: Private
extension TopFavoriteViewModel {
    private func fetch() {
        items.updateNoBind([])
        switch selectedSegment {
        case .weekly:
            getDataWeekly()
            break
        case .cumulative:
            getDataCumulative()
            break
        }
    }
    
    func getRegistDate(_ completion: @escaping JString) {
        manager.call(endpoint: .getRegistDate, completion: response)
        
        func response(_ response: ResponseRegistDate?, success: Bool) {
            if(success) {
                if let date = response?.data?.regisDate?.format(with: .IMTYYYYMMddhhMM, to: .IMTMMSignaldd)?.toDate() {
                    let value = getDateLabel(date)
                    completion(value)
                } else {
                    let value = getDateLabel()
                    completion(value)
                }
            }
        }
    }
    
    func getDataWeekly() {
        var cacheItems = [OshiUmaRanking]()
        self.manager.call(endpoint: .getOshiUmaWeeklyRankList, completion: responseOshiUmaRanking)
        
        func responseOshiUmaRanking(_ response: ResponseOshiUmaRanking?, success: Bool) {
            if let items = response?.items {
                cacheItems = items
                self.manager.call(endpoint: .getOshiUmaList, completion: responseOshiUma)
            } else {
                self.items.value = cacheItems
            }
        }
        
        func responseOshiUma(_ response: ResponseOshiUma?, success: Bool) {
            //TODO: Map 2 API to get favorite field
            if let list = response?.items {
                cacheItems.forEach { item in
                    item.favorite = list.first(where: { item.blr == $0.blr })?.getFavorite() ?? false
                }
            }
            
            self.items.value = cacheItems
        }
    }
    
    func getDataCumulative() {
        var cacheItems = [OshiUmaRanking]()
        self.manager.call(endpoint: .getOshiUmaRankList, completion: responseOshiUmaRanking)
        
        func responseOshiUmaRanking(_ response: ResponseOshiUmaRanking?, success: Bool) {
            if let items = response?.items {
                cacheItems = items
                self.manager.call(endpoint: .getOshiUmaList, completion: responseOshiUma)
            } else {
                self.items.value = cacheItems
            }
        }
        
        func responseOshiUma(_ response: ResponseOshiUma?, success: Bool) {
            //TODO: Map 2 API to get favorite field
            if let list = response?.items {
                cacheItems.forEach{ iOshiUmaRanking in
                    iOshiUmaRanking.favorite = list.first(where: { iOshiUmaRanking.blr == $0.blr })?.getFavorite() ?? false
                }
            }
            
            self.items.value = cacheItems
        }
    }

}
