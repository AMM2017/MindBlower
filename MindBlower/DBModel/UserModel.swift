//
//  User.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 27.10.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var email: String = ""
}
