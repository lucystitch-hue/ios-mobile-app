//
//  RaceCurrentViewModel.swift
//  IMT-iOS
//
//  Created by dev on 09/03/2023.
//

import Foundation
import UIKit

protocol CurrentRaceViewModelProtocol {
    var indexDate: Int { get set }
    var indexPlace: Int { get set }
    var raceByDates: ObservableObject<[IRaceByDateModel]> { get set }
    var raceByPlaces: ObservableObject<[IRaceByPlaceModel]> { get set }
    var races: ObservableObject<[RaceModel]> { get set }
    var onTransaction:(JLinks) { get set }
    var onTransactionWhenDidChoice:(JLinks) { get set }
    var onBackgroundColor: JColor { get set }
    var onTabColor: ((_ date: UIColor,_ place: UIColor) -> Void) { get set }
    
    
    func numCollection(_ collectionView: UICollectionView) -> Int
    func getCollection(_ collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell
    func getSizeCollection(_ collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> CGSize
    func getMinimumLineSpacing(_ collectionView: UICollectionView) -> CGFloat
    func getEdges(_ collectionView: UICollectionView, isCenter: Bool) -> UIEdgeInsets
    
    func didSelectCollection(_ collectionView: UICollectionView, atIndexPath indexPath: IndexPath)
    
    func numSection(_ tableView: UITableView) -> Int
    func getTableCell(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell
    func getHeightFooter(_ tableView: UITableView, section: Int) -> CGFloat
    func getFooterView(_ tableView: UITableView, section: Int) -> UIView?
    func didChoice(_ tableView: UITableView, section: Int)
    
    func updateIndexDate(_ indexDate: Int)
    func getCacheIndexDate() -> Int
    func setup(data: IMTceData)
}

class CurrentRaceViewModel {
    var raceByDates: ObservableObject<[IRaceByDateModel]> = ObservableObject<[IRaceByDateModel]>([])
    var raceByPlaces: ObservableObject<[IRaceByPlaceModel]> = ObservableObject<[IRaceByPlaceModel]>([])
    var races: ObservableObject<[RaceModel]> = ObservableObject<[RaceModel]>([])
    
    var indexDate: Int = -1 {
        didSet {
            if(raceByDates.value?.count != 0) {
                guard let info = raceByDates.value?[indexDate].info else { return }
                let cachePlaces = raceByPlaces.value
                raceByPlaces.value = info.places
                indexPlace = getCacheIndexPlace(cachePlaces, current: raceByPlaces.value)
                let iRacePlace = info.places[indexPlace]
                guard let backgroundColor = iRacePlace.getBackgroundColor() else { return }
                onBackgroundColor(backgroundColor)
                onTabColor(info.tabDateColor, info.tabPlaceColor)
            }
        }
    }
    var indexPlace: Int = -1 {
        didSet {
            races.value?.removeAll()
            if(raceByPlaces.value!.count > indexPlace) {
                guard let iRacePlace = raceByPlaces.value?[indexPlace] else { return }
                races.value = iRacePlace.races;
                guard let backgroundColor = iRacePlace.getBackgroundColor() else { return }
                onBackgroundColor(backgroundColor)
            }
        }
    }
    
    var onTransaction: (JLinks) = { _ in }
    var onTransactionWhenDidChoice: (JLinks) = { _ in }
    var onBackgroundColor: JColor = { _ in }
    var onTabColor: ((UIColor, UIColor) -> Void) = { _,_ in}
    
    init(_ rawData: IMTceData) {
        setup(data: rawData)
    }
}

extension CurrentRaceViewModel: CurrentRaceViewModelProtocol {
    func numCollection(_ collectionView: UICollectionView) -> Int {
        if(collectionView.tag == 1) {
            return raceByDates.value?.count ?? 0
        } else if(collectionView.tag == 2) {
            return raceByPlaces.value?.count ?? 0
        } else {
            return 0
        }
    }
    
    func getCollection(_ collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView.tag == 1) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RaceDateCell.identifier, for: indexPath) as? RaceDateCell else { return UICollectionViewCell() }
            
            let index = indexPath.row
            let isFocus = index == indexDate
            let iRaceByDate = raceByDates.value?[index]
            let date = iRaceByDate?.date
            let selectedColor = iRaceByDate?.info.tabDateColor
            let borderColor = raceByDates.value?[index].info.tabDateColor
            cell.setup(date: date, isFocus: isFocus, selectedColor: selectedColor, borderColor: borderColor)
            
            return cell
        } else if(collectionView.tag == 2) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RacePlaceCell.identifier, for: indexPath) as? RacePlaceCell else { return UICollectionViewCell() }
            
            let index = indexPath.row
            let isFocus = index == indexPlace
            let iRacePlace = raceByPlaces.value?[index]
            let selectedColor = iRacePlace?.getTabPlaceColor()
            let borderColor = iRacePlace?.getTabPlaceColor()
            
            cell.setup(place: iRacePlace?.place, isFocus: isFocus, selectedColor: selectedColor, borderColor: borderColor)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func getSizeCollection(_ collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> CGSize {
        var height = collectionView.bounds.size.height
        var width = collectionView.bounds.size.width
        let spaceVertical = 0.0
        
        if(collectionView.tag == 1) {
            let numVisible = Double(Constants.NumItemConfigure.raceDate)
            let space = (RaceDateCell.space * (numVisible - 1))
            let lineShadow = (1 * 2.0)
            
            width = (width - space - lineShadow) / numVisible
        } else if (collectionView.tag == 2) {
            let numVisible = Double(Constants.NumItemConfigure.raceArea)
            let space = (RacePlaceCell.space * (numVisible - 1))
            
            width = (width - space) / numVisible
        }
        
        height = height - spaceVertical * 2
        
        return CGSize(width: width, height: height)
    }
    
    func getMinimumLineSpacing(_ collectionView: UICollectionView) -> CGFloat {
        if(collectionView.tag == 1) {
            return RaceDateCell.space
        } else if(collectionView.tag == 2) {
            return RacePlaceCell.space
        }
        
        return 0
    }
    
    func getEdges(_ collectionView: UICollectionView, isCenter: Bool = false) -> UIEdgeInsets {
        if(isCenter) {
            if(collectionView.tag == 1) {
                let space = 1.0
                return UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
            } else if(collectionView.tag == 2) {
                var width = collectionView.bounds.size.width
                
                let numVisible = Double(Constants.NumItemConfigure.raceArea)
                let space = (RacePlaceCell.space * (numVisible - 1))
                let lineShadow = (1 * 2.0) - (numVisible - 1) * 2
                
                width = (width - space - lineShadow - 20.0) / numVisible
                
                let count = CGFloat(raceByPlaces.value!.count);
                let totalWidth = width * (count)
                let totalSpace = RacePlaceCell.space * (count - 1)
                
                let leftInset = (collectionView.bounds.width - CGFloat(totalWidth + totalSpace)) / 2
                let rightInset = leftInset
                
                return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
            }
        }
        
        return UIEdgeInsets.zero
    }
    
    func didSelectCollection(_ collectionView: UICollectionView, atIndexPath indexPath: IndexPath) {
        if(collectionView.tag == 1) {
            indexDate = indexPath.item
        } else if(collectionView.tag == 2) {
            indexPlace = indexPath.item
        }
        
        collectionView.reloadData()
    }
    
    func numSection(_ tableView: UITableView) -> Int {
        return races.value?.count ?? 0
    }
    
    func getTableCell(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RaceCell.identifier) as? RaceCell else { return UITableViewCell()}
        let index = indexPath.section
        let iRace = races.value?[index]
        let iRacePlace = raceByPlaces.value?[indexPlace]
        
        cell.setup(iRace, atIndex: index, rankColor: iRacePlace?.getRankColor())
        cell.delegate = self;
        
        return cell
    }
    
    func getFooterView(_ tableView: UITableView, section: Int) -> UIView? {
        return FooterLine()
    }
    
    func getHeightFooter(_ tableView: UITableView, section: Int) -> CGFloat {
        return section < races.value!.count - 1 ? Constants.HeightConfigure.smallFooterLine : 0
    }
    
    func didChoice(_ tableView: UITableView, section: Int) {
        guard let race = races.value?[section],
              let url = race.linkUrl else { return }
        let link: JMLink = (url: url, post: false)
        
        self.onTransactionWhenDidChoice(link)
    }
    
    func updateIndexDate(_ indexDate: Int) {
        self.indexDate = indexDate
    }
    
    func getCacheIndexDate() -> Int {
        let defaultIndex = getYearDefaultIndex()
        let index = (indexDate == -1 || Constants.flagFutureRace) ? defaultIndex : indexDate
        
        return index
    }
    
    func getCacheIndexPlace(_ cachePlaces: [IRaceByPlaceModel]?, current currentPlaces: [IRaceByPlaceModel]?) -> Int {
        guard let cachePlaces = cachePlaces,
              let currentPlaces = currentPlaces, Constants.displayDefaultPreferredSetting == false else {
            Constants.displayDefaultPreferredSetting = false
            return getCurrentPlaceInPreferred(currentPlaces)
        }
        
        let isEqualNumber = indexPlace < currentPlaces.count
        if(indexPlace != -1 && isEqualNumber) {
            let cachePlace = cachePlaces[indexPlace]
            let currentPlace = currentPlaces[indexPlace]
            
            if (currentPlace.place == cachePlace.place) {
                return indexPlace
            } else {
                for i in 0..<currentPlaces.count {
                    let iPlace = currentPlaces[i]
                    if(iPlace.place == cachePlace.place) {
                        return i
                    }
                }
            }
        }
        
        return getCurrentPlaceInPreferred(currentPlaces)
    }
    
    func setup(data: IMTceData) {
        let currentDate = Date.japanDate.beginningOfDay()
        Constants.needToCheckFutureRace = currentDate == Constants.cacheSysdate
        
        let data = convert(data)
        self.raceByDates.value = data
    }
}

//MARK: Private
extension CurrentRaceViewModel {
    private func convert(_ rawData: IMTceData) -> [IRaceByDateModel] {
        var dict: [String: IRaceInfo] = [:]
        
        //Group by date
        let races = rawData.races
        let holidays = rawData.holidays
        
        for i in 0..<races.count {
            let item = races[i]
            let key = item.date ?? ""
            var value = dict[key]
            
            let place = IRaceByPlaceModel(place: item.place, races: item.races, coller: item.coller)
            
            if(value != nil) {
                value?.places.append(place)
            } else {
                let color = getColorByColler(coller: item.coller, date: key, holidays: holidays)
                let info = IRaceInfo(tabDateColor: color.tabDate, tabPlaceColor: color.tabPlace, backgroundColor: color.background, places: [place])
                value = info
            }
            
            dict[key] = value
        }
        
        return dict.sorted(by: {$0.key.toDate()! < $1.key.toDate()!}).map { (k, v) in
            return IRaceByDateModel(date: k, info: v)
        }
    }
    
    private func getColorByColler(coller: String, date: String, holidays: [String]) -> (tabDate: UIColor, tabPlace: UIColor, background: UIColor) {
        let fmtDate = date.toDate()?.toString(format: .dashDate)
//        let isHoliday = holidays.contains { return $0 == fmtDate }
        let orginalRaceColler = RaceColler(rawValue: coller)
        var tabDateColor = orginalRaceColler?.tabDateColor() ?? .red
        let tabPlaceColor = orginalRaceColler?.tabPlaceColor() ?? .red
        let backgroundColor = orginalRaceColler?.backgroundColor() ?? .red
        
        //TODO: If date is holiday and date is saturday or sunday. tabDateColor priority is statuday or sunday.
        let date = date.toDate()
        let dayOfWeek = date?.getHumanReadableDayString()
        
        if(dayOfWeek == "Saturday") {
            tabDateColor = RaceColler.tabColorOfStatuday()
        } else if(dayOfWeek == "Sunday") {
            tabDateColor = RaceColler.tabColorOfSunday()
        } else {
            tabDateColor = RaceColler.tabNormalDateColor()
        }
        
        return (tabDateColor, tabPlaceColor, backgroundColor)
    }
    
    private func getYearDefaultIndex() -> Int {
        let currentHour = Date.japanDate.getHour()
        let currentDate = Date.japanDate.beginningOfDay()
        Constants.cacheSysdate = currentDate
        let isTransferHour = currentHour >= Constants.System.hourGetFutureRace
        updatePropYearDefaultIndex(isTransferHour)
        
        if(isTransferHour) {
            guard let index = raceByDates.value?.firstIndex(where: { return $0.date.toDate(.IMTYYYYMMDD)?.compare(currentDate) == .orderedDescending }) else {
                return getLastIndex()
            }
            return index
        } else {
            guard let index = raceByDates.value?.firstIndex(where: { return $0.date.toDate(.IMTYYYYMMDD)?.compare(currentDate) == .orderedSame }) else {
                return getLastIndex()
            }
            return index
        }
        
        func getLastIndex() -> Int {
            guard let index = raceByDates.value?.firstIndex(where: { return $0.date.toDate(.IMTYYYYMMDD)?.compare(currentDate) == .orderedDescending }) else {
                let count = raceByDates.value?.count ?? 1
                return count - 1
            }
            return index
        }
    }
    
    private func updatePropYearDefaultIndex(_ isTransferHour: Bool) {
        if(Constants.needToCheckFutureRace == false) {
            Constants.needToCheckFutureRace = isTransferHour
            Constants.flagFutureRace = true
        } else {
            Constants.flagFutureRace = false
        }
    }
    
    private func getCurrentPlaceInPreferred(_ places: [IRaceByPlaceModel]?) -> Int {
        let currentValue = PreferredDisplayType(rawValue: Utils.getPreferredDisplaySetting()) ?? .east
        let currentIndex = places?.firstIndex(where: { return PreferredDisplayType(rawValue: $0.coller) == currentValue}) ?? 0
        
        return currentIndex
    }
}

extension CurrentRaceViewModel: RaceCellDelegate {
    func didShowVideo(atIndex index: Int, link: JMLink) {
        onTransaction(link)
    }
    
    func didShowResult(atIndex index: Int, link: JMLink) {
        onTransaction(link)
    }
    
    func didShowDetail(atIndex index: Int, link: JMLink) {
        onTransactionWhenDidChoice(link)
    }
}
