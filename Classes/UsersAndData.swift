//
//  UsersAndData.swift
//  ProfileApp
//
//  Created by Александр Федоткин on 23.11.2023.
//

import Foundation
import UIKit
import Alamofire

class User : Decodable {
    static let sharedInstance = User()
    
    var accessToken : String = ""
    var user : UserData? = nil
    
    private init(){}
}
class UserData : Decodable {
    static let sharedInstanceUserData = UserData()
    
    var email : String = ""
    var id : Int = 0
    private init(){}
}

class Authentication {
    func signUp(email: String, password: String,complition: @escaping (Result<User, AFError>) -> Void) {
        let url = "http://localhost:3000/register"
        
        let requestBody = ["email" : email, "password" : password]
        
        AF.request(url, method: .post, parameters: requestBody).responseDecodable(of: User.self) { response in
            complition(response.result)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, AFError>) -> Void) {
        let url = "http://localhost:3000/login"
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: User.self) { response in
            completion(response.result)
        }
    }
}
