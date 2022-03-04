//
//  Menu.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/10.
//

import Foundation

struct Menu: Codable {
    
    var records: [Records]
    
    struct Records: Codable {
        
        var fields: Fields
        
        struct Fields: Codable  {
            
            var itemID: String  //品項ID
            var recordID: String //品項recordID
            var itemName: String//品名
            var type: String    //飲料類型
            var sugar: [String] //甜度（推薦的選項）
            var ice: [String]   //冰塊（推薦的選項）
            var fixSugar: Bool? //固定甜度
            var fixIce: Bool?    //固定冰塊
            var fixSize: Bool?    //固定尺寸
            var limited: Bool?   //莊園限定
            var addBubble: Bool? //是否可加珍珠
            var description: String //品項說明
            var origin: String  //產地
            var size: [String]  //尺寸（推薦的選項）
            var hot: Bool?       //是否可作熱飲
            var hotMPrice: Double?  //熱飲M金額
            var coldMPrice: Double?  //冷飲M金額
            var coldLPrice: Double?  //冷飲L金額
            
        }
    }
    
}
