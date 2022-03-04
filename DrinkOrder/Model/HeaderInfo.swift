//
//  HeaderInfo.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/17.
//

import Foundation

struct HeaderInfo {
    
    internal init(consigneeName: String? = nil , userName: String? = nil , phone: String? = nil, date: String? = nil) {
        self.consigneeName = consigneeName
        self.userName = userName
        self.phone = phone
        self.date = date
    }
    
    //取件人名稱
    var consigneeName: String?
    //使用者名稱
    var userName: String?
    //電話
    var phone: String?
    //日期
    var date: String?
    
}
