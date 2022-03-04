//
//  OrderHeader_status.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/25.
//

import Foundation

enum Status {
    
    case complete, cancel , send ,confirm
    
    var statusText: String {
        switch self {
        case .complete:
            return "完成訂單"
        case .cancel:
            return "取消訂單"
        case .send:
            return "已送出"
        case .confirm:
            return "確認訂單"
        }
    }
    
}
