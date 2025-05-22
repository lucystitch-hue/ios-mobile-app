//
//  TableWidgetProtocol.swift
//  IMT-iOS
//
//  Created by dev on 18/06/2023.
//

import Foundation
import UIKit

protocol TableWidgetProtocol {
    func registerCell(_ tableView: UITableView)
    func numSection(_ tableView: UITableView) -> Int
    func numCell(_ tableView: UITableView, section: Int) -> Int
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getHeader(_ tableView: UITableView, section: Int) -> UIView?
    func getHeightHeader(_ tableView: UITableView, section: Int) -> CGFloat
    func getFootter(_ tableView: UITableView, section: Int) -> UIView?
    func getHeightFootter(_ tableView: UITableView, section: Int) -> CGFloat
    func didChoice(_ tableView: UITableView, indexPath: IndexPath)
}

extension TableWidgetProtocol {
    func getHeader(_ tableView: UITableView, section: Int) -> UIView? {
        return nil
    }
    
    func getHeightHeader(_ tableView: UITableView, section: Int) -> CGFloat {
        return 0.0
    }
    
    func getFootter(_ tableView: UITableView, section: Int) -> UIView? {
        return nil
    }
    
    func getHeightFootter(_ tableView: UITableView, section: Int) -> CGFloat {
        return 0.0
    }

    func didChoice(_ tableView: UITableView, indexPath: IndexPath) {
        
    }
    
    func registerCell(_ tableView: UITableView) {
        
    }
}
