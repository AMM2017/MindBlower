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
    private final let API_ROOT_URL = "https://mind-blower.herokuapp.com/"
    private var user_id: Int? = nil
    private var token: String? = nil
    
    init() {
        loadAuthData()
    }
    
    func loadAuthData() {
        let defaults = UserDefaults.standard
        self.user_id = defaults.integer(forKey: "user_id")
        self.token = defaults.string(forKey: "token")
    }
    
    func saveAuthData() {
        let defaults = UserDefaults.standard
        defaults.set(self.user_id, forKey: "user_id")
        defaults.set(self.token, forKey: "token")
    }
    
    public func isAuthenticated() -> Bool {
        return user_id != nil && token != nil;
    }
    
    public func logout() {
        user_id = nil
        token = nil
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "user_id")
        defaults.removeObject(forKey: "token")
    }
    
    private func TokenObtained(data: NSDictionary)
    {
        self.token = data.value(forKey: "token") as? String
        self.user_id = data.value(forKey: "id") as? Int
        saveAuthData()
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
    
    public func saveRemoteUser(user: UserInfo){
        let defaults = UserDefaults.standard
        defaults.set(user.asDictionary(), forKey: "current_user")
    }
    
    public func loadRemoteUser(onUserFetched: @escaping (UserInfo) -> ()){
        if !isAuthenticated() {
            fatalError("Can't provide user while not authenticated")
        }
        
        let url = API_ROOT_URL + "account/\(self.user_id!)/"
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
                    let userInfo = UserInfo().configure(for: userJSON)
                    self.saveRemoteUser(user: userInfo)
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
        let defaults = UserDefaults.standard
        guard let userDict: NSDictionary = defaults.data(forKey: "current_user") as! NSDictionary? else{
            return nil
        }
        
        return UserInfo().configure(for: userDict)
        //return (defaults.data(forKey: "current_user") ?? nil) as! UserInfo?
    }
    
    public func GetTop10(onSuccess: (Any?) -> (), onFailure: (Any?) -> ()) {
        // TODO: Generate top10
    }
}
