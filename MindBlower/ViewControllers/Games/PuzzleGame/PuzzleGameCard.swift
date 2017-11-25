//
//  PuzzleGameCard.swift
//  MindBlower
//
//  Created by Kuroyan Juliett on 24.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation

class PuzzleGameCard {
    public var id = 0
    public var state: GameCardState = .closed
    public var siblingId = 0
    
    public static var backImageId = 0
    
    init(id: Int, state: GameCardState = .closed, siblingId: Int = 0) {
        self.id = id
        self.state = state
        self.siblingId = siblingId
    }
    
    func setSibling(with id: Int) {
        self.siblingId = id
    }

    static func !=(lhs: PuzzleGameCard, rhs: PuzzleGameCard) -> Bool {
        return lhs.id != rhs.siblingId
   }

    static func ==(lhs: PuzzleGameCard, rhs: PuzzleGameCard) -> Bool {
        return lhs.id == rhs.siblingId
    }
}
