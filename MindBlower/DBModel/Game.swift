//
//  User.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 27.10.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import RealmSwift

class Game: Object{
    @objc dynamic var id: Int = 0
    @objc dynamic var displayName: String = ""
    @objc dynamic var descr: String = ""
    @objc dynamic var imageName: String = ""
    
    func toString() -> String {
        return "Game \(displayName)"
    }
}

