//
//  SubscriberNumberLinkageViewModel.swift
//  IMT-iOS
//
//  Created by dev on 14/03/2023.
//

import Foundation
import UIKit

class SubscriberNumberLinkageViewModel: BaseViewModel {

    func gotoChangeTheOnlineVotingInformation(_ controller: UIViewController?) {
        guard let controller = controller else { return }
        let vc = VotingOnlineVC(type: .ipatOne, original: true)
        controller.push(vc)
    }
    
    var listSubNumerLinks: ObservableObject<[SubNumerLinksModel]> = ObservableObject<[SubNumerLinksModel]>([])
 
    override init() {
        super.init()
        self.listSubNumerLinks.value = getListsubNumerLinks()
 
    }
}

extension SubscriberNumberLinkageViewModel {

    private func getListsubNumerLinks() -> [SubNumerLinksModel] {
        return [
            SubNumerLinksModel(subscriberNumber: "Subscriber Number: 232234", pars: "P-ARS Number: 232234", pin: "PIN: ****", titleBtn: "Primary", isPriority: true),
            SubNumerLinksModel(subscriberNumber: "Subscriber Number: 232234", pars: "P-ARS Number: 232234", pin: "PIN: ****", titleBtn: "Set as Priority", isPriority: false)

        ]
    }
}


protocol SubscriberNumberLinkageViewModelProtocol {
    var listSubNumerLinks: ObservableObject<[SubNumerLinksModel]> { get set }
    func getViewFooterInSection(_ tableView: UITableView) -> UIView
    func getNumberSections(_ tableView: UITableView) -> Int
    func getCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell
    func getHeightFooter(_ tableView: UITableView,  section: Int) -> CGFloat
    

}

extension SubscriberNumberLinkageViewModel: SubscriberNumberLinkageViewModelProtocol {
    func getNumberSections(_ tableView: UITableView) -> Int {
        return self.listSubNumerLinks.value?.count ?? 0
    }
    
    func getViewFooterInSection(_ tableView: UITableView) -> UIView {
        let vFooter = UIView()
        vFooter.backgroundColor = .clear
        return vFooter
    }
    
    func getCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: SubNumerLinksCell.identifier) as? SubNumerLinksCell else { return UITableViewCell() }
       let index = indexPath.section
       let item = self.listSubNumerLinks.value?[index]
       cell.setup(item)
       return cell
    }
    
    func getHeightFooter(_ tableView: UITableView,  section: Int) -> CGFloat {
        return CGFloat(SubNumerLinksCell.heightFooter)
    }
    
    func didSelected(_ tableView: UITableView, indexPath: IndexPath, controller : UIViewController) {
        self.gotoChangeTheOnlineVotingInformation(controller)
    }
}

