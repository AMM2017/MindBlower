//
//  MBBackend.swift
//  MindBlower
//
//  Created by Kuroyan Juliett on 07.12.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Alamofire

class MBBackend {
    //ObtainToken(credentials)
    private final let API_ROOT_URL = "http://172.20.10.3:8080/"
    private var user_id: Int? = nil
    private var token: String? = nil
    
    public func isAuthenticated() -> Bool {
        return user_id != nil && token != nil;
    }
    
    public func logout() {
        user_id = nil
        token = nil
    }
    
    private func TokenObtained(data: NSDictionary)
    {
        self.token = data.value(forKey: "token") as? String
        self.user_id = data.value(forKey: "id") as? Int
    }
    
    public func ObtainToken(credentials: [String: String], onSuccess: @escaping (NSDictionary) -> (), onFailure: @escaping (NSDictionary) -> ()) {
        let url = API_ROOT_URL + "token/obtain/";
        let headers = [
            "Content-Type": "application/json"
        ]
        
        print(try! JSONEncoder().encode(credentials))
        //return Alamofire.request(url, parameters: credentials, method: .post);
        Alamofire.request(url, method: .post, parameters: credentials, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        self.TokenObtained(data: JSON)
                        onSuccess(JSON)
                    }
                    //self.TokenObtained(data: response.data)
                case .failure:
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        onFailure(JSON)
                    }
                }
            }
    }
    
    public func loadRemoteUser(onUserFetched: @escaping (UserInfo) -> ()){
        if !isAuthenticated() {
            fatalError("Can't provide user while not authenticated")
        }
        
        let url = API_ROOT_URL + "account/\(self.user_id!)/"
        print(url)
        let headers = [
            "Authorization": "Token \(self.token ?? "empty_token")"
        ]
        Alamofire
            .request(url, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result{
                case .success:
                    let userJSON = response.result.value as! NSDictionary
                    let userInfo = UserInfo()
                    userInfo.configure(for: userJSON)
                    onUserFetched(userInfo)
                case .failure:
                    let _ = ""
            }
        }
    }
    
    public func getCurrentUserObject(onUserFetched: @escaping (UserInfo) -> ()) {
        guard let localUser = loadLocalUser() else{
            loadRemoteUser(onUserFetched: onUserFetched)
            return;
        }
        onUserFetched(localUser)
    }
    
    private func loadLocalUser() -> UserInfo? {
        return nil
    }
    
    public func GetTop10(onSuccess: (Any?) -> (), onFailure: (Any?) -> ()) {
        // TODO: Generate top10
    }
}
