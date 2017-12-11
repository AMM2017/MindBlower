//
//  GameListViewController.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 06.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import UIKit
import RealmSwift
import VK_ios_sdk.VKSdk

class GameListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellHeight: CGFloat = 400
    let cellBorderWidth: CGFloat = 3
    
    public static let reuseId = "gameListViewController_reuseId"
    private var gameList: Results<Game>? = nil
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        gameList = realm.objects(Game.self)
        
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        
        self.navigationItem.hidesBackButton = true
        try! realm.write {
            realm.deleteAll()
            let game1 = Game()
            game1.id = 0
            game1.displayName = "15 Puzzle"
            game1.imageName = "puzzleImg"
            game1.descr = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sit amet ante nibh. Vestibulum sem nunc, ornare vitae pulvinar ut, iaculis non quam. Aliquam tempus vel massa non molestie."
            realm.add(game1)
            
            let game2 = Game()
            game2.id = 1
            game2.displayName = "Remember the Path"
            game2.imageName = "pathImg"
            game2.descr = "Uisque laoreet ultrices erat, ac molestie velit eleifend at. Quisque ac varius erat. Nullam vitae eros porttitor, cursus tortor maximus, pellentesque urna. Sed in gravida est, ac pulvinar tortor. Sed elementum condimentum dui rhoncus laoreet."
            realm.add(game2)
        }
        
        gameList = realm.objects(Game.self)
        self.collectionView?.allowsMultipleSelection = false;
        super.viewDidLoad()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let res = gameList?.count ?? 0
        return res
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameListCell.reuseId, for: indexPath) as! GameListCell
        
        let currentGame = gameList![indexPath.row]
        cell.configure(for: currentGame)
        
        cell.layer.borderWidth = cellBorderWidth
        cell.layer.borderColor = UIColor(red: 196.0 / 255.0, green: 150.0 / 255.0, blue: 100.0 / 255.0, alpha: 1).cgColor
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: cellHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = gameList![indexPath.row]
        let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: GameInfoViewController.reuseId) as! GameInfoViewController
        targetViewController.game = game
        self.navigationController?.pushViewController(targetViewController, animated: true)
    }
}
