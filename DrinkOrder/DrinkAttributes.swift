//
//  DrinkAttributes.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/16.
//

import Foundation
import UIKit

//冰塊
enum Ice: String {
    
    case regular = "正常" , less = "少冰", low = "微冰", no = "去冰", hot = "熱"
    
    func getIndex() -> Int {
        var int = 0
        
        switch self {
        case .regular:
            int = 0
        case .less:
            int = 1
        case .low:
            int = 2
        case .no:
            int = 3
        case .hot:
            int = 4
        }
        
        return int
    }
    
    static func getIce(int: Int) -> Ice {
        var ice = Ice.no
        
        switch int {
        case 0:
            ice = Ice.regular
        case 1:
            ice = Ice.less
        case 2:
            ice = .low
        case 3:
            ice = .no
        case 4:
            ice = .hot
        default:
            ice = Ice.no
        }
        
        return ice
    }
    
    
}
//甜度
enum Sugar: String {
    case regular = "全糖" , less = "七分", half = "五分", quarter = "三分", free = "無糖"
    
    func getIndex() -> Int {
        var int = 0
        
        switch self {
        case .regular:
            int = 0
        case .less:
            int = 1
        case .half:
            int = 2
        case .quarter:
            int = 3
        case .free:
            int = 4
        }
        return int
    }
    
    static func getSugar(int: Int) -> Sugar {
        var sugar = Sugar.free
        
        switch int {
        case 0:
            sugar = Sugar.regular
        case 1:
            sugar = Sugar.less
        case 2:
            sugar = Sugar.half
        case 3:
            sugar = Sugar.quarter
        case 4:
            sugar = Sugar.free
        default:
            sugar = Sugar.free
        }
        
        return sugar
    }
    
}
//尺寸
enum Size: String {
    case M = "M" , L = "L"
    
    func getIndex() -> Int {
        var int = 0
        
        switch self {
        case .M:
            int = 0
        case .L:
            int = 1
        }
        return int
    }
    
    
    static func getSize(int: Int) -> Size {
        var size = Size.M
        
        switch int {
        case 0:
            size = Size.M
        case 1:
            size = Size.L
        default:
            size = Size.M
        }
        
        return size
    }
    
}
