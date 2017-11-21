//
//  collectionViewCell.swift
//  p
//
//  Created by Kuroyan Artur on 03.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import UIKit


struct GameCard {
    public var id: Int = 0
    public var imageName: String = ""
}

let cards = [GameCard]()

class PuzzleGameCell: UICollectionViewCell {
    static func !=(lhs: PuzzleGameCell, rhs: PuzzleGameCell) -> Bool {
        if lhs.frontImage != rhs.frontImage {
            return true
        }
        return false
    }
    
    static func ==(lhs: PuzzleGameCell, rhs: PuzzleGameCell) -> Bool {
        if lhs.frontImage == rhs.frontImage {
            return true
        }
        return false
    }
    
    @IBOutlet weak var card: UIImageView!
    
    let backImage = #imageLiteral(resourceName: "back")
    var frontImage = #imageLiteral(resourceName: "front0")
    
    func setImg(img: UIImage) {
        frontImage = img
    }
    
    var imageIsBack: Bool {
        return card.image == backImage
    }
    
    
    func turn() {
        if self.imageIsBack {
            turnImage(with: {
                self.card.image = self.frontImage
                self.card.contentMode = .scaleAspectFit
            })
        } else {
            turnImage(with: {
                self.card.image = self.backImage
                self.card.contentMode = .scaleAspectFill
            })
        }
    }
    
    private func turnImage(with anim: @escaping () -> ()) {
        UIImageView.transition(with: card, duration: 0.2, options: .transitionFlipFromLeft, animations: anim, completion: nil)
    }
}


