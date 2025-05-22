//
//  RegisterInfoOtherViewModel.swift
//  IMT-iOS
//
//  Created by dev on 15/03/2023.
//

import Foundation
import UIKit

protocol UpdatePersonalInfoOtherViewModelProtocol {
    var items: ObservableObject<[InputStepRegisterModel]> { get set }
    var indexSelected: ObservableObject<Int> { get set }
    var onHideSkip: ObservableObject<Bool> { get set }
    
    func nextStep(_ controller: UpdatePersonalInfoOtherVC?)
    func skip(_ controller: UpdatePersonalInfoOtherVC?)
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getFooter(_ tableView: UITableView, section: Int) -> UIView
    func getHeightFooter(_ tableView: UITableView, section: Int) -> Float
    func didSelected(_ tableView: UITableView, indexPath: IndexPath)
}

class UpdatePersonalInfoOtherViewModel: BaseViewModel {
    var items: ObservableObject<[InputStepRegisterModel]> = ObservableObject<[InputStepRegisterModel]>([])
    var data: [RegisterStepType: [InputStepRegisterModel]] = [:]
    var indexSelected: ObservableObject<Int> = ObservableObject<Int>(-1)
    var onHideSkip: ObservableObject<Bool> = ObservableObject<Bool>(false)
    
    private var type: RegisterStepType!
    private var form: FormUpdatePersonalInfo!
    
    init(data: [RegisterStepType: [InputStepRegisterModel]], type: RegisterStepType, form: FormUpdatePersonalInfo?) {
        super.init()
        self.type = type
        self.form = form
        self.items.value = data[type]
        self.data = data
        
        switch type {
        case .service:
            self.onHideSkip.value = false
            break
        case .question:
            self.onHideSkip.value = true
            break
        }
    }
}

//MARK: Private
extension UpdatePersonalInfoOtherViewModel {
    private func pushStep(_ controller: UpdatePersonalInfoOtherVC, type: RegisterStepType, value: String) {
        let vc = UpdatePersonalInfoOtherVC(data: self.data, type: type, form: self.form)
        controller.push(vc)
    }
    
    private func getValueChoice() -> String {
        let listValue = items.value!.map({ return "\($0.getValue())" }).joined(separator: "")
        return listValue
    }
}

extension UpdatePersonalInfoOtherViewModel: UpdatePersonalInfoOtherViewModelProtocol {
    func nextStep(_ controller: UpdatePersonalInfoOtherVC?) {
        guard let controller = controller else { return }
        switch self.type {
        case .service:
            self.form?.serviceType = getValueChoice()
            self.pushStep(controller, type: .question, value: "")
            break
        case .question:
            self.form?.regisReason = getValueChoice()
            self.pushEndStep(controller)
            break
        default:
            break
        }
    }
    
    func skip(_ controller: UpdatePersonalInfoOtherVC?) {
        guard let controller = controller else { return }
        switch self.type {
        case .service:
            self.form?.serviceType = getValueChoice()
            break
        case .question:
            self.form?.regisReason = getValueChoice()
            break
        default:
            return
        }
        
        self.pushEndStep(controller)
    }
    
    func pushEndStep(_ controller: UpdatePersonalInfoOtherVC?) {
        guard let controller = controller else { return }
        let vc = ConfirmUpdateUserVC(style: .new, form: form)
        controller.push(vc)
    }
    
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IMTCheckboxCell.identifier) as? IMTCheckboxCell else { return UITableViewCell() }
        let item = items.value?[indexPath.section]
        cell.setup(item: item, indexAt:indexPath)
        cell.onChecked = { [weak self] indexPath in
            self?.didSelected(tableView, indexPath: indexPath)
        }
        
        return cell
    }
    
    func getFooter(_ tableView: UITableView, section: Int) -> UIView {
        return  UIView()
    }
    
    func getHeightFooter(_ tableView: UITableView, section: Int) -> Float {
        return Float(IMTCheckboxCell.space)
    }
    
    func didSelected(_ tableView: UITableView, indexPath: IndexPath) {
        guard let item = items.value?[indexPath.section] else { return }
        item.selected = !item.selected
        tableView.reloadSections([indexPath.section], with: .none)
    }
}
