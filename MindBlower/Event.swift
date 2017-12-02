//
//  Event.swift
//  MindBlower
//
//  Created by Kuroyan Juliett on 24.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation

class Event<T> {
    
    typealias EventHandler = (T) -> ()
    
    private var eventHandlers = [EventHandler]()
    
    func addHandler(handler: @escaping EventHandler) {
        eventHandlers.append(handler)
    }
    
    func raise(data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
}
