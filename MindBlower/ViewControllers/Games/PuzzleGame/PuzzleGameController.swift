//
//  CollectionViewController.swift
//  p
//
//  Created by Kuroyan Artur on 02.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import UIKit


@available(iOS 10.0, *)
class PuzzleGameController: UICollectionViewController {
    let cellReuseID = "puzzleGameCell_reuseId"
    var gameSpaceWidth = 0
    var gameSpaceHeight = 0
    var firstTurnedCell: PuzzleGameCell? = nil
    var turnedCellsCount = -1
    var canTurn = true
    let difficulties = [
        CGSize(width: 2, height: 3),
        CGSize(width: 4, height: 4),
        CGSize(width: 4, height: 6)
    ]
    var size: CGSize! = nil
    
    public var difficulty = 0
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(size.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(size.width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! PuzzleGameCell
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:(gameSpaceWidth - Int((size?.width)!)) / Int((size?.width)!), height: (gameSpaceHeight - Int((size?.height)!)) / Int((size?.height)!))
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumInteritemSpacing = 0.1
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        return cell
    }
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        size = difficulties[difficulty]
        gameSpaceWidth = Int(self.collectionView!.bounds.width)
        gameSpaceHeight = Int(self.collectionView!.bounds.height - (self.navigationController?.navigationBar.bounds.height)! - UIApplication.shared.statusBarFrame.size.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if turnedCellsCount == -1 {
            setImages()
            
            turnAll()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (t) in
                self.turnAll()
            }
            turnedCellsCount = 0
        }
    }
    
    private func setImages() {
        var indexArray: [IndexPath] = []
        
        for i in 0...Int((size?.height)!) - 1 {
            for j in 0...Int((size?.width)!) - 1 {
                indexArray.append(IndexPath(row: j, section: i))
            }
        }
        for i in 0...Int((size?.width)!) * Int((size?.height)!) - 1 {
            let n = Utils.getRandom(0, indexArray.count)
            let ip = indexArray[n]
            indexArray.remove(at: n)
            let cell = self.collectionView?.cellForItem(at: ip) as! PuzzleGameCell
            cell.setImg(img: UIImage(named: "front\(i / 2)")!)
        }
    }
    
    private func turnAll() {
        for i in 0...Int((size?.height)!) - 1 {
            for j in 0...Int((size?.width)!) - 1 {
                let cell = self.collectionView?.cellForItem(at: IndexPath(row: j, section: i)) as! PuzzleGameCell
                cell.turn()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !canTurn {
            return
        }
        
        let cell = self.collectionView?.cellForItem(at: indexPath) as! PuzzleGameCell
        if !cell.imageIsBack {
            return
        }
        
        cell.turn()
        
        if let cell2 = firstTurnedCell {
            canTurn = false
            
            if cell != cell2 {
                Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (t) in
                    cell.turn()
                    cell2.turn()
                    self.canTurn = true
                }
            } else {
                turnedCellsCount += 2
                if turnedCellsCount == Int((size?.width)!) * Int((size?.height)!) {
                    gameFinish()
                }
                self.canTurn = true
            }
            
            firstTurnedCell = nil
            
        } else {
            firstTurnedCell = cell
        }
    }
    
    private func gameFinish() {
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (t) in
            self.turnedCellsCount = -1
            self.turnAll()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "gameEndViewController")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}


