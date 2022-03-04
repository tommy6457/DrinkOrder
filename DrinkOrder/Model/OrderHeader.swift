//
//  OrderHeader.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/22.
//

import Foundation

struct OrderHeader: Codable {
    
    var records: [Records]
    
    struct Records: Codable {
        
        var id: String?
        var fields: Fields
        
        struct Fields: Codable {
            
            var orderNumber: String     //訂單號碼。規則：年月日＋六碼流水號(20210215000001)
            var userName: String        //使用者名稱
            var date: String            //取貨日期欄位。格式：(yyyy-MM-dd,hh:mm)
            var phone: String           //聯絡電話
            var consigneeName: String   //聯絡人名稱
            var status: String          //訂單狀態：完成訂單、尚未取餐、取消訂單
            var totalPrice: Int         //訂單總金額
            var orderItem: [String]?    //訂單項目id
            
        }
    }
}
