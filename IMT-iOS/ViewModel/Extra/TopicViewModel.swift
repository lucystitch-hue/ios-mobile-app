//
//  TopicViewModel.swift
//  IMT-iOS
//
//  Created by dev on 08/03/2023.
//

import Foundation
import UIKit
protocol TopicViewModelProtocol {
    var dataOfSection: ObservableObject<[TopicModel]> { get set }
    var index: Int { get set }
    var bindingIndex: Bool { get set }
    var isFirstLoad: Bool { get set }
    
    func next()
    func previous()
    func caculateHeight(heightHeader: Float?, paddingVertical: Float?, numVisible: Int?, heightContent: Float?) -> Float
    func setIndexNoBind(index: Int)
    func getNumberPage() -> Int
}

class TopicViewModel: BaseViewModel {
    var dataOfSection: ObservableObject<[TopicModel]> = ObservableObject<[TopicModel]>([])
    
    //MARK: Private Prop
    private var matrix: [[TopicModel]] = []
    var bindingIndex: Bool = true
    var isFirstLoad: Bool = true
    
    var index: Int = 0 {
        didSet {
            self.isFirstLoad = false
            updateDataOfSection(index)
            bindingIndex = true
        }
    }
    
    init(data: [TopicModel]) {
        super.init()
        self.matrix = convert(data)
        self.updateDataOfSection(index)
    }
}

//MARK: Private
extension TopicViewModel {
    private func updateDataOfSection(_ index: Int) {
        self.dataOfSection.value = matrix[index]
    }
    
    private func convert(_ rawData: [TopicModel]) -> [[TopicModel]] {
        var matrix: [[TopicModel]] = [];
        var flagChild: [TopicModel] = [];
        var flag = 0
        
        for i in 0..<rawData.count {
            let item = rawData[i]
            
            //Step 1: Add item to flagChild
            flagChild.append(item)
            flag += 1
            
            //Step 2: Handle when end element
            if(i == rawData.count - 1) {
                matrix.append(flagChild)
                break
            }
            
            //Step 3: Handle number of flagChild
            if(flag == Constants.NumItemConfigure.topic) {
                matrix.append(flagChild)
                flagChild = []
                flag = 0
            }
        }
        
        return matrix;
    }
}

extension TopicViewModel: TopicViewModelProtocol {
    
    func next() {
        let max = self.matrix.count
        if(index + 1 < max) {
            index += 1
        }
    }
    
    func previous() {
        if(index - 1 >= 0) {
            index -= 1
        }
    }
    
    func caculateHeight(heightHeader: Float?, paddingVertical: Float?, numVisible: Int?, heightContent: Float? = nil) -> Float {
        guard let heightHeader = heightHeader else { return 0 }
        guard let paddingVertical = paddingVertical else { return 0 }
        guard let numVisible = numVisible else { return 0 }
        
        let numItem = numVisible;
        let hDefaultSection = Float(numItem) * TopicCell.height
        let hSection = heightContent ?? hDefaultSection
        let hContent = hSection + paddingVertical * 2
        let hSummary = hContent + heightHeader
        
        return hSummary
    }
    
    func setIndexNoBind(index: Int) {
        self.bindingIndex = false
        self.index = index
    }
    
    func getNumberPage() -> Int {
        return self.matrix.count
    }
    
    
}
