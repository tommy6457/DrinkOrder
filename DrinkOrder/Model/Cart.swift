//
//  Cart.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/17.
//

import Foundation

struct Cart {
    
    internal init(ice: Ice? = nil, sugar: Sugar? = nil, size: Size? = nil, bubble: Bool, quantity: Int? = nil, price: Int? = nil, itemID: String? = nil, itemName: String? = nil) {
        self.ice = ice
        self.sugar = sugar
        self.size = size
        self.bubble = bubble
        self.quantity = quantity
        self.price = price
        self.itemID = itemID
        self.itemName = itemName
    }
    
    
    var ice: Ice!
    var sugar: Sugar!
    var size: Size!
    var bubble: Bool!
    var quantity: Int!
    var price: Int!
    var itemID: String!
    var itemName: String!
    
    
}
