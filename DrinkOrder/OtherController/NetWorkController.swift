//
//  NetWorkController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/8.
//

import Foundation
import UIKit

struct NetWorkController {
    
    static let shared = NetWorkController()
    static let apikey = "Your KEY" 
    //URL
    static let getDrinkTypeURL = "https://api.airtable.com/v0/appF1OKCnZdGbqDDt/DrinkType?sort%5B0%5D%5Bfield%5D=createdTime&sort%5B0%5D%5Bdirection%5D=asc&api_key=\(NetWorkController.apikey)"
    static let getMenuURL = "https://api.airtable.com/v0/appF1OKCnZdGbqDDt/Menu?sort%5B0%5D%5Bfield%5D=createdTime&sort%5B0%5D%5Bdirection%5D=asc&api_key=\(NetWorkController.apikey)"
    static let getOrderItemURL = "https://api.airtable.com/v0/appF1OKCnZdGbqDDt/OrderItem?&api_key=\(NetWorkController.apikey)"
    static let orderItemURL = "https://api.airtable.com/v0/appF1OKCnZdGbqDDt/OrderItem"
    static let orderHeaderURL = "https://api.airtable.com/v0/appF1OKCnZdGbqDDt/OrderHeader"
    static let getOrderHeaderURL = "https://api.airtable.com/v0/appF1OKCnZdGbqDDt/OrderHeader?sort%5B0%5D%5Bfield%5D=createdTime&sort%5B0%5D%5Bdirection%5D=desc&api_key=\(NetWorkController.apikey)"
    
    //GET Airtable - Menu
    func fetchMenu(urlString: String ,completion: @escaping ((Result< Menu , NetWorkError>) -> Void)){
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidurl))
            return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            guard let menu = try? decoder.decode(Menu.self, from: data)
            else {
                completion(.failure(.invalidJsonFormat))
                return  }
            
            
            completion(.success(menu))
            
        }.resume()
        
    }
    
    //GET Airtable - DrinkType
    func fetchDrinkType(urlString: String ,completion: @escaping ((Result< DrinkType , NetWorkError>) -> Void)){
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidurl))
            return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            guard let drinkTypes = try? decoder.decode(DrinkType.self, from: data)
            else {
                completion(.failure(.invalidJsonFormat))
                return  }
            
            
            completion(.success(drinkTypes))
            
        }.resume()
        
    }
    
    //POST Airtable - OrderItem
    func postOrderItem(urlString: String ,orderItem: OrderItem ,completion: @escaping ((Result< OrderItem , NetWorkError>) -> Void)){
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidurl))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(NetWorkController.apikey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(orderItem)
        
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()

            guard let orderItem = try? decoder.decode(OrderItem.self, from: data)
            else {
                completion(.failure(.invalidJsonFormat))
                return  }
            
            completion(.success(orderItem))
            
        }.resume()
        
    }
    
    //POST Airtable - OrderHeader
    func postOrderHeader(urlString: String ,orderHeader: OrderHeader ,completion: @escaping ((Result< OrderHeader , NetWorkError>) -> Void)){
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidurl))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(NetWorkController.apikey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(orderHeader)
        
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()

            guard let orderHeader = try? decoder.decode(OrderHeader.self, from: data)
            else {
                completion(.failure(.invalidJsonFormat))
                return  }
            
            completion(.success(orderHeader))
            
        }.resume()
        
    }
    //PATCH Airtable - OrderHeader
    func patchOrderHeader(urlString: String ,orderHeader: OrderHeader ,completion: @escaping ((Result< OrderHeader , NetWorkError>) -> Void)){
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidurl))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(NetWorkController.apikey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(orderHeader)
        
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()

            guard let orderHeader = try? decoder.decode(OrderHeader.self, from: data)
            else {
                completion(.failure(.invalidJsonFormat))
                return  }
            
            completion(.success(orderHeader))
            
        }.resume()
        
    }
    //GET Airtable - OrderHeader
    func fetchOrderHeader(urlString: String ,where condition: (field: String?, value: String?),completion: @escaping ((Result< OrderHeader , NetWorkError>) -> Void)){
        
        var urlStringWithCondition = urlString
        
        if let field = condition.field,
           let value = condition.value{
            
            urlStringWithCondition = urlStringWithCondition + "&filterByFormula=" + "SEARCH(\"\(value)\",{\(field)})".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
        }
        
        guard let url = URL(string: urlStringWithCondition) else {
            completion(.failure(.invalidurl))
            return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            
            guard let orderHeader = try? decoder.decode(OrderHeader.self, from: data)
            else {
                completion(.failure(.invalidJsonFormat))
                return  }
            
            completion(.success(orderHeader))
            
            
        }.resume()
        
    }
    
    //DELETE Airtable - OrderHeader
    func deleteOrderHeader(urlString: String , id: String ,completion: @escaping ((Result< Bool, NetWorkError>) -> Void)){
        
        var urlStringWithCondition = urlString + "?records[]=\(id)"
        
        urlStringWithCondition = urlStringWithCondition.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        guard let url = URL(string: urlStringWithCondition) else {
            completion(.failure(.invalidurl))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(NetWorkController.apikey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(true))

        }.resume()
        
    }
    
    //GET Airtable - OrderItem
    func fetchOrderItem(urlString: String ,where condition: (field: String?, value: String?),completion: @escaping ((Result< OrderItem , NetWorkError>) -> Void)){
        
        var urlStringWithCondition = urlString
        
        if let field = condition.field,
           let value = condition.value{
            
            urlStringWithCondition = urlStringWithCondition + "&filterByFormula=" + "SEARCH(\"\(value)\",{\(field)})".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
        }
        
        guard let url = URL(string: urlStringWithCondition) else {
            completion(.failure(.invalidurl))
            return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            
            guard let orderItem = try? decoder.decode(OrderItem.self, from: data)
            else {
                completion(.failure(.invalidJsonFormat))
                return  }
            
            completion(.success(orderItem))
            
        }.resume()
        
    }
    
    //DELETE Airtable - OrderItem
    func deleteOrderItem(urlString: String , records: OrderHeader.Records ,completion: @escaping ((Result< Bool, NetWorkError>) -> Void)){
        
        var urlStringWithCondition = urlString + "?"
        var index = 0
        records.fields.orderItem?.forEach({ itemID in
            if index == 0 {
                urlStringWithCondition += "records[]=\(itemID)"
            }else{
                urlStringWithCondition += "&records[]=\(itemID)"
            }
            
            index += 1
        })
        
        
        urlStringWithCondition = urlStringWithCondition.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        guard let url = URL(string: urlStringWithCondition) else {
            completion(.failure(.invalidurl))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(NetWorkController.apikey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(true))

        }.resume()
        
    }
    //格式化為 OrderHeader-date 的字串
    func getOrderHeaderDateTime(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "(yyyy-MM-dd,HH:mm)"
        return formatter.string(from: date)
        
    }
    //for OrderHeader-orderNumber取號使用
    func getOrderHeaderDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: date)
        
    }
    //補前置零
    func getFrontZero(count: Int, value: Int) -> String{
        
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = count
        let stringNum = NSNumber(value: value)
        
        return formatter.string(from: stringNum)!
        
    }
    
    //show alert
    func showAlert(title: String , message: String ,handler: (UIAlertController) -> Void ){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(ok)
        alertController.view.tintColor = .systemBlue
        
        handler(alertController)
    }
    
}
