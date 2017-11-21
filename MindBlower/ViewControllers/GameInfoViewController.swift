//
//  GameInfoViewController.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 06.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import UIKit

class GameInfoViewController: UIViewController{
    public static let reuseId = "GameInfoView_reuseId"
    
    public var game: Game? = nil
    
    private let colors = [
        UIColor(red: 0.0, green: 212.0 / 255.0, blue: 77.0 / 255.0, alpha: 1),
        UIColor.init(red: 255.0 / 255.0, green: 190.0 / 255.0, blue: 37.0 / 255.0, alpha: 1),
        UIColor.init(red: 233.0 / 255.0, green: 48.0 / 255.0, blue: 56.0 / 255.0, alpha: 1)
    ]
    
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameDifficultySelector: UISegmentedControl!
    
    @IBAction func diffcultyChanged(_ sender: Any) {
        let selector = sender as! UISegmentedControl
        
        selector.tintColor = colors[selector.selectedSegmentIndex]
    }
    
    override func viewDidLoad() {
        guard let normalGame = game else {
            fatalError("This can't be shown wo a game set")
        }
        
        gameNameLabel.text = normalGame.displayName
        gameDescriptionLabel.text = normalGame.descr
        gameImage.image = UIImage(named: normalGame.imageName)
        gameDifficultySelector.tintColor = colors[gameDifficultySelector.selectedSegmentIndex]
    }
    
    @IBAction func playBtnTouched(_ sender: Any) {
        var segueName: String
        guard let normalGame = game else {
            fatalError("This can't be shown without a game set")
        }
        //enum: Int
        //.rawValue
        switch (normalGame.id) {
        case 0:
            segueName = "puzzleGameSegue"
            break
        case 1:
            segueName = "pathGameSegue"
            break
        default:
            fatalError("Attempted to start unknown game")
        }
        
        performSegue(withIdentifier: segueName, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "puzzleGameSegue"{
            if #available(iOS 10.0, *) {
                let puzzleController = segue.destination as! PuzzleGameController
                puzzleController.difficulty = gameDifficultySelector.selectedSegmentIndex
            }
        }
    }
}
