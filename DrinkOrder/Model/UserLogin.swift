//
//  UserLogin.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/4/2.
//

import Foundation

struct UserLoginBody: Codable {
    
    let username: String
    let password: String
    
}

struct UserLoginResponse: Codable {
    
    //Error
    let errorCode: String?
    let errorSummary: String?
    
    
    //SUCCESS
    let status: String?
    let sessionToken: String?
    let _embedded: Embedded?
    
    struct Embedded: Codable {
        
        let user: User
        
        struct User: Codable {
            
            let id: String
            
            let profile: Profile
            
            struct Profile: Codable {
                
                let login: String
                let firstName: String
                let lastName: String
                
            }
            
        }
        
    }
    
}
