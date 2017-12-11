//
//  UserInfo.swift
//  MindBlower
//
//  Created by Kuroyan Juliett on 10.12.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import UIKit

class UserInfo {
    public var firstName = ""
    public var lastName = ""
    public var email = ""
    public var vkId = -1
    
    func configure(for dict: NSDictionary) -> UserInfo{
        firstName = dict.value(forKey: "first_name") as! String
        lastName = dict.value(forKey: "last_name") as! String
        email = dict.value(forKey: "email") as! String
        vkId = dict.value(forKey: "vk_id") as! Int
        
        return self
    }
    
    func asDictionary() -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(self.firstName, forKey: "first_name")
        dict.setValue(self.lastName, forKey: "last_name")
        dict.setValue(self.email, forKey: "email")
        dict.setValue(self.vkId, forKey: "vk_id")
        return NSDictionary(dictionary: dict)
    }
}
