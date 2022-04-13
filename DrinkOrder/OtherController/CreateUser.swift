//
//  CreateUser.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/3/30.
//

import Foundation

struct CreateUserBody: Codable {
    
    let profile: Profile
    
    struct Profile: Codable {
        let firstName: String
        let lastName: String
        let email: String
        let login: String
        
    }
    
    let credentials: Credentials
    
    struct Credentials: Codable {
        let password: String
        
    }
}

struct CreateUserResponse: Codable {
    let status: String?
    let errorCauses: [ErrorCauses]?
    
    struct ErrorCauses: Codable {
        let errorSummary: String
        
    }
}
