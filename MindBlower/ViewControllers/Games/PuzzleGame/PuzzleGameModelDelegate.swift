//
//  GameModelDelegate.swift
//  MindBlower
//
//  Created by Kuroyan Juliett on 25.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation

protocol PuzzleGameModelDelegate {
    func turnCard(with id: Int)
    func turnCards(with firstId: Int, and secondId: Int)
    func gameDidEnd()
}
