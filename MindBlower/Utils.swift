//
//  Utils.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 06.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation

class Utils{
    public static func getRandom(_ min: Int, _ max: Int) -> Int {
        let result: Int = Int( arc4random_uniform(UInt32(max - min)) + UInt32(min) )
        return result
    }
}
