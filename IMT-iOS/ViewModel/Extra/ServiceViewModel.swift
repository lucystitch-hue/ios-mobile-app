//
//  ServiceViewModel.swift
//  IMT-iOS
//
//  Created by dev on 10/03/2023.
//

import Foundation
import UIKit

protocol ServiceViewModelProtocol {
    var services: ObservableObject<[Service]> { get set }
    var onChoiceServiceOrderTicket: ((_ isQrCode: Bool) -> Void) { get set }
    
    func numSection(tableView: UITableView) -> Int
    func getCell(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell
    func getHeightCell(tableView: UITableView, atIndexPath indexPath: IndexPath) -> CGFloat
    func getFooterView(tableView: UITableView, section: Int) -> UIView?
    func getHeightFooter(tableView: UITableView, section: Int) -> CGFloat
}

class ServiceViewModel {
    
    var services: ObservableObject<[Service]> = ObservableObject<[Service]>([])
    var onChoiceServiceOrderTicket: ((Bool) -> Void) = { _ in }
    
    private var delegate: ServiceOrderRoomCellDelegate!
    
    
    init(services: [Service], asDelegate delegate: ServiceOrderRoomCellDelegate) {
        self.services.value = services
        self.delegate = delegate
    }
}

extension ServiceViewModel: ServiceViewModelProtocol {
    func numSection(tableView: UITableView) -> Int {
        return self.services.value?.count ?? 0
    }
    
    func getCell(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.section
        let service = services.value?[index]
        
        switch service {
        case .order:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceOrderTicketCell.identifier) as? ServiceOrderTicketCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        case .club, .categoryKeiba, .guide, .requiredVote, .soku, .youtube, .beginerGuide:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceImageCell.identifier) as? ServiceImageCell else { return UITableViewCell() }
            cell.setup(image: service?.image())
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func getHeightCell(tableView: UITableView, atIndexPath indexPath: IndexPath) -> CGFloat {
        return Constants.HeightConfigure.serviceCell
    }
    
    func getFooterView(tableView: UITableView, section: Int) -> UIView? {
        return UIView()
    }
    
    func getHeightFooter(tableView: UITableView, section: Int) -> CGFloat {
        return Constants.HeightConfigure.spaceService
    }
}

extension ServiceViewModel: ServiceOrderTicketCellDelegate {
    func serviceOrderTicketFromQRCode(_ cell: ServiceOrderTicketCell) {
        self.onChoiceServiceOrderTicket(true)
    }
    
    func serviceOrderTicketOnline(_ cell: ServiceOrderTicketCell) {
        self.onChoiceServiceOrderTicket(false)
    }
}
