
import Foundation
import UIKit

class PuzzleGameModel {
    var cards = [PuzzleGameCard]()
    
    typealias DifficultyEntry = (x: Int, y: Int)
    fileprivate let diffs: [DifficultyEntry] = [
        (x: 2, y: 3),
        (x: 4, y: 4),
        (x: 4, y: 6)
    ]
    
    private var size: DifficultyEntry
    private var lastState: GameCardState = .locked
    private var openedCards = [Int]()
    private var closedCardsCount = 0
    var cardInPair: [Int]!
    var delegate: PuzzleGameModelDelegate?
    
    init(difficulty: Int) {
        size = diffs[difficulty]
        closedCardsCount = getColumnsCount() * getRowsCount()
        for i in 0...closedCardsCount {
            cards.append(PuzzleGameCard(id: i))
        }
    }
    
    func getRowsCount() -> Int {
        return size.y
    }
    
    func getColumnsCount() -> Int{
        return size.x
    }
    
    
    func tryCard(currentId: Int) {
        if cards[currentId].state == .opened {
            return
        }

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
            
            if cards[openedCards[0]] == cards[openedCards[1]] {
                closedCardsCount -= 2
                cards[openedCards[0]].state = .opened
                cards[openedCards[1]].state = .opened
                if closedCardsCount == 0 {
                    delegate?.gameDidEnd()
                }
            } else {
                delegate?.turnCards(with: openedCards[0], and: openedCards[1])
            }
            openedCards.removeAll()
            lastState = .opened

        case .shownSecond, .locked: ()
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
        delegate?.gameWasStarted()
        
        setPairs()
        closedCardsCount = getColumnsCount() * getRowsCount() //???
        for i in 0...closedCardsCount {
            cards[i].state = .closed
        }
        lastState = .locked
    }
    
    func startChooseCards() {
        lastState = .closed
    }
}
