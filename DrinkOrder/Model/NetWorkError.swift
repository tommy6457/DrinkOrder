//
//  NetWorkError.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/8.
//

import Foundation

enum NetWorkError:Error {
    case requestFailed
    case invalidurl
    case invalidResponse
    case invalidData
    case invalidJsonFormat
    case other(String)
    
}
