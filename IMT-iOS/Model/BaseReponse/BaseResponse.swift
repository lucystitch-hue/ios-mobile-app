//
//  BaseResponse.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import Foundation

protocol BaseResponse : Codable {
    associatedtype R: Codable;
    var success: Bool { get set }
    var message: String? { get set }
    
    init(dictionary: [String: AnyObject]);
    func getSuccess() -> Bool
}

extension BaseResponse {
    init(dictionary: [String: AnyObject]) {
        self = try! JSONDecoder().decode(R.self, from: JSONSerialization.data(withJSONObject: dictionary)) as! Self;
    }
    
    func getSuccess() -> Bool {
        return self.success
    }
}
