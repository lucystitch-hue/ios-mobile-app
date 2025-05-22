//
//  BeginerGuideViewModel.swift
//  IMT-iOS
//
//  Created by dev on 22/05/2023.
//

import Foundation
import UIKit

protocol BeginGuideViewModelProtocol{
    var onLoadContent: ObservableObject<(view: UIView?, intital: Bool)> { get set }
    var onTransition: JTransAgent { get set }
}

class BeginerGuideViewModel {
    var onLoadContent: ObservableObject<(view: UIView?, intital: Bool)> = ObservableObject<(view: UIView?, intital: Bool)>((nil, true))
    
    var onTransition: JTransAgent = { _ in }
    
    private var data = BeginnerGuideRow.allCases
    //MARK: Config UI
    private let paddingHorizotalCard: CGFloat = 20.0
    private let bottomCard: CGFloat = 15.0
    private let heightContentCard: CGFloat = 97.0
    
    init() {
        let view = convertUI(rows: data)
        self.onLoadContent.value = (view, false)
    }
}

//MARK: Private
extension BeginerGuideViewModel {
    //MARK: Convert data to user interface
    private func convertUI(rows: [BeginnerGuideRow]) -> UIStackView {
        let svContent = UIStackView()
        svContent.axis = .vertical
        svContent.spacing = 20.0
        
        builder()
        
        return svContent
        
        //TODO: Add topics of guide to content stackview
        func builder() {
            for i in 0..<rows.count {
                let iRow = rows[i]
                let topics = iRow.topics()
                
                var row: UIView!
                
                if(topics.count > 1) {
                    row = getRow(topics)
                } else {
                    row = getTopic(topic: topics.first!)
                }
                
                svContent.addArrangedSubview(row)
            }
        }
        
        //TODO: Add topics to row(StackView). If number topics bigger than 1
        func getRow(_ topics: [BeginnerGuideTopic]) -> UIStackView {
            let svRow = UIStackView()
            svRow.axis = .horizontal
            svRow.spacing = 10.0
            svRow.distribution = .fillEqually
            
            topics.forEach { iTopic in
                let vTopic = getTopic(topic: iTopic)
                svRow.addArrangedSubview(vTopic)
            }
            
            return svRow
        }
        
        //TODO: Create topic and caculate height
        func getTopic(topic: BeginnerGuideTopic) -> TopicCardComponent {
            let vTopic = TopicCardComponent()
            vTopic.delegate = self
            vTopic.setup(title: topic.rawValue, theme: topic.theme(), data: topic.items())
            vTopic.translatesAutoresizingMaskIntoConstraints = false
            vTopic.onContentHeight = { height in
                vTopic.heightAnchor.constraint(equalToConstant: height).isActive = true
            }
            return vTopic
        }
    }
}

extension BeginerGuideViewModel: BeginGuideViewModelProtocol {
    
}

extension BeginerGuideViewModel: TopicCardComponentDelegate {
    func didSelectTopicCard(_ component: TopicCardComponent, atIndex indexPath: IndexPath, object: Any) {
        guard let sections = object as? [TopicCardModel] else { return }
        let section = sections[indexPath.section]
        let subItem = section.subItems[indexPath.item]
        
        guard let beginGuide = BeginnerGuide(rawValue: subItem.label), beginGuide != .empty else { return }
        switch beginGuide {
            case .purchasedByInternetVoting:
                transitionFromSafari(beginGuide.transInfo().url)
                break
            default :
                let trans = beginGuide.transInfo()
                onTransition(trans)
                break
        }
    }
    
    func topicCard(_ component: TopicCardComponent, insetForSectionAt section: Int, object: Any) -> UIEdgeInsets {
        guard let sections = object as? [TopicCardModel] else { return .zero }
        let iSection = sections[section]
        
        if(iSection.subItems.count > 1) {
            let bottom: CGFloat = sections.count > 1 && sections.count - 1 == section ? bottomCard : 0
            return UIEdgeInsets(top: 0, left: paddingHorizotalCard, bottom: bottom, right: paddingHorizotalCard)
        }
        
        return .zero
    }
    
    func heightTopicCard(_ component: TopicCardComponent) -> CGFloat {
        return heightContentCard
    }
    
    func paddingHorizotalTopicCard(_ component: TopicCardComponent) -> CGFloat {
        return paddingHorizotalCard
    }
    
    func heightHeader(_ component: TopicCardComponent) -> CGFloat {
        return 10.0
    }
}

extension BeginerGuideViewModel {
    private func transitionFromSafari(_ string: String) {
        if let url = URL(string: string) {
            UIApplication.shared.open(url)
        }
    }
}

