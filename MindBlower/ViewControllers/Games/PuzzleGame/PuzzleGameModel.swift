//
//  PuzzleGameModel.swift
//  MindBlower
//
//  Created by Kuroyan Juliett on 24.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import UIKit

class PuzzleGameModel {
    var cards = [PuzzleGameCard]()
    
    private let difficulties = [
        CGSize(width: 2, height: 3),
        CGSize(width: 4, height: 4),
        CGSize(width: 4, height: 6)
    ]
    
    private var size: CGSize!
    private var lastState: GameCardState = .locked
    private var openedCards = [Int]()
    private var closedCardsCount = 0
    var cardInPair: [Int]!
    var delegate: PuzzleGameModelDelegate?
    
    init(difficulty: Int) {
        size = difficulties[difficulty]
        closedCardsCount = getColumnsCount() * getRowsCount()
        for i in 0...closedCardsCount {
            cards.append(PuzzleGameCard(id: i))
        }
        setPairs()
    }
        
    func getRowsCount() -> Int {
        return Int(size.height)
    }
    
    func getColumnsCount() -> Int{
        return Int(size.width)
    }
    
    
    func tryCard(currentId: Int) {
        switch lastState {
        case .closed, .opened:
            delegate?.turnCard(with: currentId)
            lastState = .shownFirst
            openedCards.append(currentId)
            
        case .shownFirst:
            if currentId == openedCards[0] {
                return
            }
            
            delegate?.turnCard(with: currentId)
            lastState = .shownSecond
            openedCards.append(currentId)
            
            if (cards[openedCards[0]] == cards[openedCards[1]]) {
                closedCardsCount -= 2
                if closedCardsCount == 0 {
                    lastState = .locked
                    delegate?.gameDidEnd()
                }
            } else {
                delegate?.turnCards(with: openedCards[0], and: openedCards[1])
            }
            openedCards.removeAll()
            lastState = .opened

        case .shownSecond, .locked:
            return
        }
    }
    
    private func setPairs() {
        let cardsCount = getColumnsCount() * getRowsCount()
        cardInPair = [Int](repeating: 0, count: cardsCount)
        
        var idArray = [Int]()
        
        for i in 0...cardsCount {
            idArray.append(i)
        }
        
        
        for i in 0...cardsCount / 2 - 1 {
            var n = Utils.getRandom(0, idArray.count - 1)
            let firstCardId = idArray[n]
            idArray.remove(at: n)
            
            n = Utils.getRandom(0, idArray.count - 1)
            let secondCardId = idArray[n]
            idArray.remove(at: n)
            
            cardInPair[firstCardId] = i
            cardInPair[secondCardId] = i 
            
            cards[firstCardId].setSibling(with: secondCardId)
            cards[secondCardId].setSibling(with: firstCardId)
        }
    }
    
    func startGame() {
        lastState = .closed
    }
}
