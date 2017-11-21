//
//  User.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 27.10.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import RealmSwift

class GameMatch: Object{
    @objc dynamic var id: Int = 0
    @objc dynamic var game: Game? = nil
    @objc dynamic var user: User? = nil
    @objc dynamic var timestamp: Date? = nil
    @objc dynamic var score: Int = 0
}


