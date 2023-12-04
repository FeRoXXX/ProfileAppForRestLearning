//
//  LoginResponse.swift
//  ProfileApp
//
//  Created by Александр Федоткин on 26.11.2023.
//

import Foundation
import Alamofire

class LoginResponse: Decodable {
    static let sharedInstance = LoginResponse()
    var email : String = ""
    var logo : String = ""
    var images : [String] = []
    
    private init(){}
}

class ResponseResult : Decodable {
    var email : String = ""
    var posts : [String] = []
    var id : Int = 0
    
    func getData(completion: @escaping (Result<[ResponseResult], AFError>) -> Void) {
        let url = "http://localhost:3000/posts"
        AF.request(url, method: .get).responseDecodable(of: [ResponseResult].self) { response in
            completion(response.result)
        }
    }
    
    func getProfileData(completion: @escaping (Result<ResponseResult, AFError>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/posts/\(User.sharedInstance.user!.id)") else {
            print("Invalid URL")
            return
        }
        
        AF.request(url).responseDecodable(of: ResponseResult.self) { response in
            print(response.result)
            switch response.result {
            case .success(let resultPosts):
                completion(.success(resultPosts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

class LogoResponseResult : Decodable {
    var logo : String = ""
    var id : Int = 0
    
    func getLogo(completion: @escaping (Result<[LogoResponseResult], AFError>) -> Void) {
        let url = "http://localhost:3000/logo"
        AF.request(url, method: .get).responseDecodable(of: [LogoResponseResult].self) { response in
            completion(response.result)
        }
    }
    
    func getProfileImage(completion: @escaping (Result<LogoResponseResult, AFError>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/logo/\(User.sharedInstance.user!.id)") else {
            print("Invalid URL")
            return
        }
        
        AF.request(url).responseDecodable(of: LogoResponseResult.self) { response in
            print("Datas: \(response.result)")
            switch response.result {
            case .success(let loginResponse):
                completion(.success(loginResponse))
                
            case .failure(let error):
                print("Error: \(error)")
                completion(.failure(error))
            }
        }
    }
}

class RegistrationUser {
    func uploadData(logoImageView: UIImage, completion: @escaping (Result<Void, AFError>) -> Void) {
        
        let url = "http://localhost:3000/logo"
        let id = User.sharedInstance.user!.id
        

        var base64LogoString : String = ""
        if let logoData = logoImageView.jpegData(compressionQuality: 0.5) {
            base64LogoString = logoData.base64EncodedString()
        }

        let parameters : [String : Any] = [
            "id" : id,
            "logo" : base64LogoString
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response {
            response in
            switch response.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class NewPost {
    func getPosts(completion: @escaping (Result<ResponseResult, AFError>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/posts/\(User.sharedInstance.user!.id)") else {
            print("Invalid URL")
            return
        }
        
        AF.request(url).responseDecodable(of: ResponseResult.self) { response in
            print(response.result)
            switch response.result {
            case .success(let resultPosts):
                completion(.success(resultPosts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func savePost(postArray: [String], postData: String,completion: @escaping (Result<Void, AFError>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/posts/\(User.sharedInstance.user!.id)") else { return }
        
        if !postArray.isEmpty {
            var newDataArray = postArray
            newDataArray.append(postData)
            guard let email = User.sharedInstance.user?.email else { return }
            guard let id = User.sharedInstance.user?.id else { return }
            
            let parameters = [
                "email" : email,
                "posts" : newDataArray,
                "id" : id
            ] as [String : Any]
            
            AF.request(url, method: .put, parameters: parameters,encoding: JSONEncoding.default).response { response in
                switch response.result {
                case .success(_):
                    if let json = try? response.result.get() {
                        print("JSON: \(json)")
                    }
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            guard let url = URL(string: "http://localhost:3000/posts") else { return }
            var newDataArray = postArray
            newDataArray.append(postData)
            guard let email = User.sharedInstance.user?.email else { return }
            guard let id = User.sharedInstance.user?.id else { return }
            
            let parameters = [
                "email" : email,
                "posts" : newDataArray,
                "id" : id
            ] as [String : Any]
            
            AF.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default).response { response in
                switch response.result {
                case .success(_):
                    if let json = try? response.result.get() {
                        print("JSON: \(json)")
                    }
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
