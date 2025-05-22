//
//  HitBettingTicketArchiveViewModel.swift
//  IMT-iOS
//
//  Created by dev on 13/03/2023.
//

import Foundation
import UIKit

protocol ListMemorialViewModelProtocol: ViewModelProtocol {
    var years: ObservableObject<[String]> { get set }
    var grades: ObservableObject<[GradeName]> { get set }
    var hitBettingTicketArchives: ObservableObject<[HitBettingTicketArchiveModel]> { get set }
    var items: ObservableObject<[IListQRModel]> { get set }
    var deleteMode: ObservableObject<DeleteTicketMode> { get set }
    var rawSelectedItemsCount: Int { get }
    var selectedItemsCount: Int { get }
    var itemsCount: Int { get }
    
    var indexYear: ObservableObject<Int> { get set }
    var indexGrade: ObservableObject<Int> { get set }
    var onUpdateYearTitle: JString { get set }
    var onUpdateGradeTitle: JString { get set }
    var onUpdateButtonDelete: JVoid { get set }
        
    func getNumberSections(_ tableView: UITableView) -> Int
    func getCell(_ controller: ListMemorialVC?, tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell
    func getHeightFooter(_ tableView: UITableView,  section: Int) -> CGFloat
    func getViewFooterInSection(_ tableView: UITableView) -> UIView
    func remove(controller: ListMemorialVC?, tableView: UITableView, atIndex index: Int)
    func removeMultiple(_ controller: ListMemorialVC?)
    func getAllNumber() -> Int
    func callAPI()
    func getNumberOfRemoveItem() -> Int
    func actionAllowDeleteMultiple(_ controller: ListMemorialVC?)
    func actionAcceptDeleteMultiple(_ controller: ListMemorialVC?)
    func resetDetectMode(_ controller: ListMemorialVC?)
}

class ListMemorialViewModel: BaseViewModel {
    var years: ObservableObject<[String]> = ObservableObject<[String]>([])
    var grades: ObservableObject<[GradeName]> = ObservableObject<[GradeName]>([])
    var hitBettingTicketArchives: ObservableObject<[HitBettingTicketArchiveModel]> = ObservableObject<[HitBettingTicketArchiveModel]>([])
    var items: ObservableObject<[IListQRModel]> = ObservableObject<[IListQRModel]>([])
    var rawItems: [IListQRModel] = []
    var limitTicketCanRegister = 0
    var onUpdateYearTitle: JString = { _ in }
    var onUpdateGradeTitle: JString = { _ in }
    var onUpdateButtonDelete: JVoid = { }
    var rawSelectedItemsCount: Int {
        return dictChoiceItem.count
    }
    
    var selectedItemsCount: Int {
        return self.items.value?.filter({ $0.choice }).count ?? 0
    }
    
    var itemsCount: Int {
        return items.value?.count ?? 0
    }
    
    var indexYear: ObservableObject<Int> = ObservableObject<Int>(0)
    var indexGrade: ObservableObject<Int> = ObservableObject<Int>(0)
    var allowDeleteMultiple: ObservableObject<Bool> = ObservableObject<Bool>(false)
    var deleteMode: ObservableObject<DeleteTicketMode> = ObservableObject<DeleteTicketMode>(.single)
    
    private var bundle: [HomeBundleKey: Any]?
    private var dictChoiceItem: Array<IListQRModel> = []
    
    init(bundle: [HomeBundleKey: Any]?) {
        super.init()
        self.bundle = bundle
        
        indexYear.bind { [weak self] value in
            self?.search()
            if let years = self?.years.value,
               let index = value, years.count > index {
                let year = index == 0 ? years[index] : "\(years[index])年"
                self?.onUpdateYearTitle(year)
                self?.onUpdateButtonDelete()
            }
        }

        indexGrade.bind { [weak self] value in
            self?.search()
            if let grades = self?.grades.value,
               let index = value, grades.count > index {
                let grade = grades[index]
                self?.onUpdateGradeTitle(grade.rawValue)
                self?.onUpdateButtonDelete()
            }
        }
    }
    
    override func refreshData() {
        super.refreshData()
        self.indexYear.value = 0
        self.indexGrade.value = 0
    }
}

//MARK: ListMemorialViewModelProtocol
extension ListMemorialViewModel: ListMemorialViewModelProtocol {
    func callAPI() {
        Utils.showProgress()
        Task { @IMTGlobal in
            
            async let listQR = try await getListData()
            async let maxinum = try await getMaximumNumberOfMemorial()
            
            try await setData(listQR, limit: maxinum)
        }
        
        @Sendable func setData(_ listQR: [IListQRModel], limit: Int) async {
            Task { @MainActor in
                indexYear.updateNoBind(0)
                indexGrade.updateNoBind(0)
                
                //TODO: Limit of Ticket
                limitTicketCanRegister = limit
                
                //TODO: Reload data on user interface of Year
                updateYear(listQR)
                
                //TODO: Reload data on user interface of Grade
                updateGrade()
                
                refreshData()
                
                Utils.hideProgress()
            }
        }
    }
    
    func getNumberSections(_ tableView: UITableView) -> Int {
        return items.value?.count ?? 0
    }
    
    func getCell(_ controller: ListMemorialVC?, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.section
        let item = items.value?[index]
        let showRadioButton = deleteMode.value == .multiple
        if(showRadioButton) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IMemorialCell.identifier) as? IMemorialCell else { return UITableViewCell() }
            cell.setup(item: item, showRadioButton: showRadioButton)
            cell.onChoice = { [weak self] (data) in
                self?.choice(controller, atIndex: index)
            }
            cell.layoutIfNeeded()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IMemorialNoRadioCell.identifier) as? IMemorialNoRadioCell else { return UITableViewCell() }
            cell.setup(item: item)
            cell.onChoice = { [weak self] (data) in
                self?.choice(controller, atIndex: index)
            }
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func getViewFooterInSection(_ tableView: UITableView) -> UIView {
        let vFooter = UIView()
        vFooter.backgroundColor = .clear
        return vFooter
    }
    
    func getHeightFooter(_ tableView: UITableView, section: Int) -> CGFloat {
        return IMemorialCell.space
    }
    
    func remove(controller: ListMemorialVC?, tableView: UITableView, atIndex index: Int) {
        controller?.showWarningWhenDeleteSingleTicket { [weak self] (actionType, warnVC) in
            guard let actionType = actionType else { return }
            
            if(actionType == .ok) {
                self?.removeAt(index)
            }
        }
    }
    
    func removeMultiple(_ controller: ListMemorialVC?) {
        let bakenIds = dictChoiceItem.map { $0.memorialId }.joined(separator: "_")
        controller?.showWarningWhenDeleteMultipleTicket(numberOfItem: dictChoiceItem.count, { [weak self] (actionType, warnVC) in
            guard let actionType = actionType else { return }
            if(actionType == .ok) {
                Utils.showProgress()
                self?.manager.call(endpoint: .multipleDeleteQR(bakenIds: bakenIds), showLoading: false, completion: responseDeleteMultipleQR(_:success:))
            }
        })
        
        func responseDeleteMultipleQR(_ data: [IListQRModel]?, success: Bool) {
            Utils.mainAsyncAfter(10) { [weak self] in
                self?.dictChoiceItem.removeAll()
                self?.deleteMode.value = .single
                self?.callAPI()
                Utils.hideProgress()
            }
        }

    }
    
    func choice(_ controller: ListMemorialVC?, atIndex index: Int) {
        execute()
        
        func execute() {
            if(deleteMode.value == .single) {
                showDetail()
            } else {
                selectedDelete()
            }
        }
        
        func selectedDelete() {
            guard let item = items.value?[index] else { return }
            item.choice = !item.choice
            let key = item.memorialId ?? ""
            let value = item
            
            if(item.choice) {
                dictChoiceItem.append(value)
            } else {
                guard let firstIndex = dictChoiceItem.firstIndex(where: { $0.memorialId == key }) else {
                    controller?.reloadAt(index)
                    return
                }
                dictChoiceItem.remove(at: firstIndex)
            }
            
            controller?.reloadAt(index)
            onUpdateButtonDelete()
            
        }
        
        func showDetail() {
            guard let controller = controller else { return }
            guard let items = items.value else { return }
            refreshData()
            controller.onGotoPreviewTicket?(items, index)
        }
    }
    
    func getAllNumber() -> Int {
        return limitTicketCanRegister
    }
    
    func getNumberOfRemoveItem() -> Int {
        return dictChoiceItem.count
    }
    
    func actionAllowDeleteMultiple(_ controller: ListMemorialVC?) {
        execute()
        
        func execute() {
            if(deleteMode.value == .single) {
                deleteMode.value = .multiple
            } else {
                if (itemsCount <= selectedItemsCount) {
                    unselectAll()
                } else {
                    selectAll()
                }
            }
            
            controller?.reloadData()
            onUpdateButtonDelete()
        }
        
        func selectAll() {
            self.items.value?.forEach({ item in
                //TODO: Update state
                item.choice = true
            })
            self.dictChoiceItem = self.rawItems.filter({ $0.choice })
        }
        
        func unselectAll() {
            self.items.value?.forEach({ item in
                item.choice = false
            })
            self.dictChoiceItem = self.rawItems.filter({ $0.choice })
        }
    }
    
    func actionAcceptDeleteMultiple(_ controller: ListMemorialVC?) {
        let numberOfDeleteItem = getNumberOfRemoveItem()
        if(numberOfDeleteItem > 0) {
            removeMultiple(controller)
        } else {
            dictChoiceItem.removeAll()
            deleteMode.value = .single
            controller?.reloadData()
        }
    }
    
    func resetDetectMode(_ controller: ListMemorialVC?) {
        rawItems.forEach { item in
            item.choice = false
        }
        dictChoiceItem.removeAll()
        deleteMode.value = .single
        controller?.reloadData()
    }
}

//MARK: API
extension ListMemorialViewModel {
    private func getListData() async throws -> [IListQRModel] {
        try await withCheckedThrowingContinuation { continuation in
            self.manager.call(endpoint: .listQR, showLoading: false, completion: response)
            
            func response(_ response: [IListQRModel]?, success: Bool) {
                if let data = response {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
    
    private func getMaximumNumberOfMemorial() async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            self.manager.call(endpoint: .sysEnv, showLoading: false, completion: response)
            
            func response(_ response: ResponseSysEnv?, success: Bool) {
                if let value = response?.getValueFromAysy01(key: .maximumNumberOfMemorial)?.integer() {
                    continuation.resume(returning: value)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
}

//MARK: Private
extension ListMemorialViewModel {
    
    private func getGrade() -> [GradeName]{
        return [.all, .GI, .GII, .GIII, .others]
    }
    
    private func getValue(_ bundle: [String: Any]) -> String {
        return bundle["value"] as? String ?? ""
    }
    
    private func filter(year: String?, grade: GradeName?) -> [IListQRModel] {
        guard let year = year?.prefix(4),
              let grade = grade else { return [] }
        
        if (year == "All") {
            return filterAll(grade)
        } else {
            return filterCondition(grade, year: String(year))
        }
    }
    
    private func updateYear(_ data: [IListQRModel]?) {
        guard let data = data else { return }
        var years: [String] = [String.MemorialString.allYear]
        
        //TODO: Sort date desc
        self.rawItems = Array(data.sorted(by: {
            if let date0 = $0.date.toDate(),
               let date1 = $1.date.toDate() {
                return date0 > date1
            } else {
                return false
            }
        }))
        
        //Year
        years += data.map({
            if let value = $0.date.toDate()?.getYear() {
                return String(value)
            }
            return ""
        }).unique().sorted(by: {
            guard let year0 = Int($0) else { return false }
            guard let year1 = Int($1) else { return false }
            return year0 < year1
        })
        
        self.years.value = years
    }
    
    private func updateGrade() {
        self.grades.value = getGrade()
    }
    
    private func filterAll(_ grade: GradeName) -> [IListQRModel] {
        
        var items: [IListQRModel] = []
        var index = 0
        
        for item in self.rawItems {
            let currentGrade = GradeName(rawValue: item.grade)
            var flagGrade = grade == .all
            
            if let currentGrade = currentGrade {
                flagGrade = grade.raws().contains(currentGrade)
            }
            
            if(flagGrade) {
                items.append(item)
            }
            
            item.rawIndex = index
            
            index += 1
        }
        
        return items
    }
    
    private func filterCondition(_ grade: GradeName, year: String) -> [IListQRModel] {
        var items: [IListQRModel] = []
        var index = 0
        
        for item in self.rawItems {
            
            item.rawIndex = index
            
            if let currentYear = item.date.format(with: .IMTYYYYMMDD, to: .IMTYYYY) {
                let currentGrade = GradeName(rawValue: item.grade)
            
                var flagGrade = grade == .all
                
                if let currentGrade = currentGrade {
                    flagGrade = grade.raws().contains(currentGrade)
                }
                
                if currentYear == year && flagGrade {
                    items.append(item)
                }
                
                index += 1
            }
        }
        
        return items
    }
    
    private func search() {
        guard let years = self.years.value else { return }
        guard let grades = self.grades.value else { return }
        guard let indexYear = self.indexYear.value else { return }
        guard let indexGrade = self.indexGrade.value else { return }
        if(years.count != 0 && grades.count != 0) {
            let year = years[indexYear]
            let grade = grades[indexGrade]
            self.items.value = self.filter(year: year, grade: grade)
        }

    }
    
    private func onChoiceCellAt(_ item: IListQRModel) {
        guard let key = item.memorialId else { return }
        let value = item
        
        if(item.choice) {
            dictChoiceItem.append(value)
        } else {
            guard let firstIndex = dictChoiceItem.firstIndex(where: { $0.memorialId == key }) else { return }
            dictChoiceItem.remove(at: firstIndex)
        }
    }
    
    private func removeAt(_ index: Int) {
        guard let item = items.value?[index] else { return }
        Utils.showProgress(false)
        manager.call(endpoint: .deleteQR(bakenId: item.memorialId), showLoading: false, completion: responseDeleteQR(_:success:))
        
        func responseDeleteQR(_ response: DeleteQRModel?, success: Bool) {
            if let status = response?.status, status == "OK" {
                Utils.mainAsyncAfter(10) { [weak self] in
                    self?.rawItems.removeAll(where: { $0.memorialId == item.memorialId })
                    self?.items.value?.remove(at: index)
                    self?.indexYear.updateNoBind(0)
                    self?.indexGrade.updateNoBind(0)
                    self?.updateYear(self?.rawItems)
                    self?.refreshData()
                    Utils.hideProgress()
                }
            }
        }
    }
}
