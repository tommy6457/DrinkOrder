//
//  DrinkType.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/8.
//  飲品類型

import Foundation

struct DrinkType: Codable {
    
    var records: [Records]
    
    struct Records: Codable {
        
        var fields: Fields
        
        struct Fields: Codable{
            
            var typeID: String
            var typeName: String
            var createdTime: String
        }
    }
    
}




