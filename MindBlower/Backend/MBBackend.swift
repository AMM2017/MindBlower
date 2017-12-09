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
    
    public func IsAuthenticated() -> Bool {
        return user_id != nil && token != nil;
    }
    
    private func TokenObtained(data: Any?)
    {
        let responseJSON = data as! NSDictionary
        self.token = (responseJSON.value(forKey: "token") as! String)
        self.user_id = (responseJSON.value(forKey: "user_id") as! Int)
    }
    
    public func ObtainToken(credentials: [String: String], onSuccess: @escaping (Any?) -> (), onFailure: @escaping (Any?) -> ()) {
        let url = API_ROOT_URL + "token/obtain/";
        
        print(try! JSONEncoder().encode(credentials))
        //return Alamofire.request(url, parameters: credentials, method: .post);
        Alamofire.request(url, method: .post, parameters: credentials, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    self.TokenObtained(data: response.data)
                    onSuccess(response.result.value)
                case .failure:
                    if let data = response.data {
                        let json = String(data:data, encoding: String.Encoding.utf8)
                        print("Failure: \(json ?? "empty_data")")
                    }
                    onFailure(response.result.value)
                }
            }
    }
    
    public func GetTop10(onSuccess: (Any?) -> (), onFailure: (Any?) -> ()) {
        // TODO: Generate top10
    }
}
