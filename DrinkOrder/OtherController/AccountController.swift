//
//  AccountController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/3/22.
//

import Foundation
import UIKit

struct AccountController {
    
    static let shared = AccountController()
    
    private let oktaDomainURL = "Your oktaDomainURL"
    private let token = "Your token"
    
    //登入
    func userLogin(userName: String , password: String, completion: @escaping (Result<UserLoginResponse ,NetWorkError>) -> Void){
        
        let task: URLSessionDataTask?
        let userLoginBody = UserLoginBody(username: userName, password: password)
        
        
        guard let url = URL(string: "\(oktaDomainURL)/api/v1/authn") else {
            completion(.failure(NetWorkError.invalidurl))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("SSWS \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(userLoginBody)
        request.httpBody = data
        request.httpMethod = "POST"
        
        task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(.failure(NetWorkError.requestFailed))
                return }
            
            guard let data = data else {
                completion(.failure(NetWorkError.invalidData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else{
                      completion(.failure(NetWorkError.invalidResponse))
                      return }
            
            let decoder = JSONDecoder()
            
            guard let userLoginResponse = try? decoder.decode(UserLoginResponse.self, from: data) else {
                
                completion(.failure(NetWorkError.invalidJsonFormat))
                return
            }
            
            //組錯誤訊息
            if httpResponse.statusCode != 200,
               let errorSummary = userLoginResponse.errorSummary,
               let errorCode = userLoginResponse.errorCode{
                
                let errorMessage = "\(errorCode): \(errorSummary)"
                
                completion(.failure(NetWorkError.other(errorMessage)))
                return
            }
            
            completion(.success(userLoginResponse))
            
        })
        
        task?.resume()
        
    }
    
    //建立帳號
    func createUserwithPassword(createUserBody: CreateUserBody ,completion: @escaping (Result< CreateUserResponse,NetWorkError >) -> Void){
        
        let task: URLSessionDataTask?
        
        guard let url = URL(string: "\(oktaDomainURL)/api/v1/users?activate=true") else {
            completion(.failure(NetWorkError.invalidurl))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("SSWS \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(createUserBody)
        request.httpBody = data
        request.httpMethod = "POST"
        
        task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(.failure(NetWorkError.requestFailed))
                return }
            
            guard let data = data else {
                completion(.failure(NetWorkError.invalidData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else{
                      completion(.failure(NetWorkError.invalidResponse))
                      return }
            
            let decoder = JSONDecoder()
            
            guard let createUserResponse = try? decoder.decode(CreateUserResponse.self, from: data) else {
                
                completion(.failure(NetWorkError.invalidJsonFormat))
                return
            }
            
            
            //組錯誤訊息
            if httpResponse.statusCode != 200,
               let errorCauses = createUserResponse.errorCauses{
                
                var errorMessage = ""
                errorCauses.forEach { errorCauses in
                    
                    if errorMessage.isEmpty {
                        errorMessage += errorCauses.errorSummary
                    }else{
                        errorMessage += ", \(errorCauses.errorSummary)"
                    }
                    
                }
                
                completion(.failure(NetWorkError.other(errorMessage)))
                return
            }
            
            completion(.success(createUserResponse))
        })
        
        task?.resume()
    }
    
    func checkPasswordFormat(pattern: String ,password: String) -> String?{
        
        if password.isEmpty {
            return "輸入值不可為空"
        }
        
        //空的就不做
        if pattern.isEmpty {
            
        }else{ //有指定pattern就檢查
            if let regex = try? NSRegularExpression(pattern: pattern, options: []){
                
                let numberOfMatches = regex.numberOfMatches(in: password, options: [], range: NSRange(location: 0, length: password.count))
                
                if numberOfMatches != password.count{
                    return "不可含有特殊字元"
                }
                
            }else{
                return "檢查字元發生錯誤"
            }
        }
        
        return nil
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
