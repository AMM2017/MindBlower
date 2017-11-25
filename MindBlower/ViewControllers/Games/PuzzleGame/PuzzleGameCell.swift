//
//  collectionViewCell.swift
//  p
//
//  Created by Kuroyan Artur on 03.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import UIKit

class PuzzleGameCell: UICollectionViewCell {    
    @IBOutlet weak var cardImage: UIImageView!
    
    var frontImageId = 0
    let backImageId = 0
    
    func turn() {
        UIImageView.transition(with: cardImage, duration: 0.2, options: .transitionFlipFromLeft, animations: {
            
            self.cardImage.image = self.cardImage.image == UIImage(named: "front\(self.frontImageId)") ?
                UIImage(named: "back\(self.backImageId)") :
                UIImage(named: "front\(self.frontImageId)")
            
            self.cardImage.contentMode = self.cardImage.image == UIImage(named: "front\(self.frontImageId)") ?
                .scaleAspectFit :
                .scaleAspectFill
            
        }, completion: nil)
    }
    
    func setImage(with id: Int) {
        frontImageId = id
    }
}



