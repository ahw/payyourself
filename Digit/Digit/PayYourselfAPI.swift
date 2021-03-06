//
//  File.swift
//  Digit
//
//  Created by Dylan on 5/4/17.
//  Copyright © 2017 Dylan. All rights reserved.
//

import Foundation
import Alamofire

class PayYourselfAPI {
    static let shared = PayYourselfAPI()
    
    private static let baseUrlString = "http://localhost:3000"
    
    
    let signupURL = "http://localhost:3000/signup"
    let loginURL = "http://localhost:3000/login"
    let plaidURL = "http://localhost:3000/plaid"
    
    var accessToken = String()
    
    //    func post(parameters: parameters){
    //        let headers: HTTPHeaders = ["Content-Type" : "application/json"]
    //
    //        let request = Alamofire.request(signupURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    //        request.responseJSON(completionHandler: { (response) in
    //            debugPrint(response)
    //            if let responseDic = response.value as? [String : Any] {
    //                return completion(responseDic, nil)
    //            } else {
    //                return completion(nil, response.error)
    //            }
    //        })
    //    }
    //
    
    func signupPost(name: String, email: String, password: String,  completion: @escaping (_ userInfo: [String : Any]?, _ error: [String : Any]?) -> Void) {
        let headers: HTTPHeaders = ["Content-Type" : "application/json"]
        let parameters: Parameters = ["name": "\(name)","email": "\(email)","password": "\(password)"]
        Alamofire.request(signupURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    print("SUCCESS_FAILURE with JSON: \(response.result.value!)")
                    if let responseDic = response.value as? [String : Any] {
                        debugPrint(responseDic)
                        return completion(responseDic, nil)
                    }
                } else {
                    print("PLAID_FAILURE with JSON: \(response.result.value!)")
                    
                    if let error = response.result.value as? [String: Any] {
                        //If you want array of task id you can try like
                        return completion(nil, error)
                    }
                }
        }
        
    }
    
    func loginPost(email: String, password: String, completion: @escaping (_ userInfo: [String : Any]?, _ error: [[String : Any]]?) -> Void) {
        let headers: HTTPHeaders = ["Content-Type" : "application/json"]
        let parameters: Parameters = ["email": "\(email)","password": "\(password)"]
        
        Alamofire.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    print("LOGIN_SUCCESS with JSON: \(response.result.value!)")
                    if let responseDic = response.value as? [String : Any] {
                        self.accessToken = responseDic["token"] as! String
                        print(self.accessToken)
                        
                        return completion(responseDic, nil)
                    }
                } else {
                    print("LOGIN_FAILURE with JSON: \(response.result.value!)")
                    
                    if let error = response.result.value as? [[String: Any]] {
                        //If you want array of task id you can try like
                        return completion(nil, error)
                    }
                }
        }
    }
    
    func plaidPost(plaidToken: String, completion: @escaping (_ userInfo: [String : Any]?, _ error: [[String : Any]]?) -> Void) {
        let headers: HTTPHeaders = ["Content-Type" : "application/json", "Authorization" : "Bearer \(self.accessToken)"]
        let parameters: Parameters = ["plaidToken": "\(plaidToken)"]
        
        Alamofire.request(plaidURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    print("LOGIN_SUCCESS with JSON: \(response.result.value!)")
                    if let responseDic = response.value as? [String : Any] {
//                        self.accessToken = responseDic["token"] as! String
//                        print(self.accessToken)
                        
                        return completion(responseDic, nil)
                    }
                } else {
                    print("LOGIN_FAILURE with JSON: \(response.result.value!)")
                    
                    if let error = response.result.value as? [[String: Any]] {
                        //If you want array of task id you can try like
                        return completion(nil, error)
                    }
                }
        }

    }
    
    func logout(){
        self.accessToken = ""
    }
    
    
    
}
