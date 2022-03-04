//
//  OrderItem.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/22.
//

import Foundation

struct OrderItem: Codable {
    
    var records: [Records]
    
    struct Records: Codable {
        
        var id: String?
        var fields: Fields
        
        struct Fields: Codable {
            
            var orderItemNumber: String //訂單項次號碼。規則：三碼流水號 ( 001 )
            var orderNumber: [String]   //訂單號碼
            var itemID: [String]        //飲料品項id
            var ice: String             //冰塊
            var sugar: String           //甜度
            var quantity: Int        //數量
            var bubble: Bool?        //加珍珠
            var subPrice: Int        //金額
            
        }
    }
}
