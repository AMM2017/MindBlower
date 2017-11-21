//
//  GameListCell.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 06.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import UIKit

class GameListCell: UICollectionViewCell {
    public static let reuseId = "GameListCell_reuseId"
    
    @IBOutlet weak var gameIcon: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    
    public var gameId: Int = -1
    
    func configure(for model: Game) {
        gameName.text = model.displayName
        gameIcon.image = UIImage(named: model.imageName)
        gameId = model.id
    }
}
