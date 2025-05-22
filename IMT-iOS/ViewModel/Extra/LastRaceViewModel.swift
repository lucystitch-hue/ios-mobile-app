//
//  RaceViewModel.swift
//  IMT-iOS
//
//  Created by dev on 14/03/2023.
//

import Foundation
import UIKit

protocol NewsViewModelProtocol {
    var news: ObservableObject<[NewModel]> { get set }
}

class NewsViewModel: NewsViewModelProtocol {

    var news: ObservableObject<[NewModel]> = ObservableObject<[NewModel]>([])
    
    init(news: [NewModel]) {
        self.news.value = news
    }
}
