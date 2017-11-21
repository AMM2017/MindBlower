//
//  User.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 27.10.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var userName: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var photoUrl: String = ""
}
