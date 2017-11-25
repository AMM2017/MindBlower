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
class PuzzleGameController: UICollectionViewController, PauseProtocol, PuzzleGameModelDelegate {

    var puzzleGameModel: PuzzleGameModel! = nil
    
    var delegateHandler: PauseProtocolDelegateHandler!
    let cellReuseID = "puzzleGameCell_reuseId"
    var gameSpaceWidth = 0
    var gameSpaceHeight = 0
    var margin = 10
    
    var rowsCount = 0
    var columnsCount = 0
    
    let backImageId = 0
    
    let showingTime = 5.0
    var showingStartTime: Date? = nil
    var pauseStartTime: Date? = nil;

    func continueGame() {
        if pauseStartTime != nil {
            let interval = showingTime - Double(pauseStartTime!.timeIntervalSince1970 - showingStartTime!.timeIntervalSince1970)
            pauseStartTime = nil

            Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { (t) in
                if self.pauseStartTime == nil {
                    self.turnAll()
                    self.puzzleGameModel.startGame()
                }
            }
        }
    }
    
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rowsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columnsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! PuzzleGameCell
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:(gameSpaceWidth - columnsCount) / columnsCount - margin, height: (gameSpaceHeight - rowsCount) / rowsCount)
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumInteritemSpacing = 0.1
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        return cell
    }
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        rowsCount = puzzleGameModel.getRowsCount()
        columnsCount = puzzleGameModel.getColumnsCount()
        
        gameSpaceWidth = Int(self.collectionView!.bounds.width)
        gameSpaceHeight = Int(self.collectionView!.bounds.height - (self.navigationController?.navigationBar.bounds.height)! - UIApplication.shared.statusBarFrame.size.height)
        
        delegateHandler = PauseProtocolDelegateHandler(delegate: self)
        puzzleGameModel.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setImages()
        
        turnAll()
        showingStartTime = Date()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (t) in
            if self.pauseStartTime == nil {
                self.turnAll()
                self.puzzleGameModel.startGame()
            }
        }
    }

    func setImages() {
        for i in 0...rowsCount * columnsCount - 1 {
            let cell = self.collectionView?.cellForItem(at: IndexPath(row: i % columnsCount, section: i / columnsCount)) as! PuzzleGameCell
            cell.setImage(with: puzzleGameModel.cardInPair[i])
        }
    }
    
    private func turnAll() {
        for i in 0...rowsCount - 1 {
            for j in 0...columnsCount - 1 {
                let cell = self.collectionView?.cellForItem(at: IndexPath(row: j, section: i)) as! PuzzleGameCell
                cell.turn()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        puzzleGameModel.tryCard(currentId: indexPath.section * columnsCount + indexPath.row)
    }
    
    func turnCard(with id: Int) {
        let cell = self.collectionView?.cellForItem(at: IndexPath(row: id % columnsCount, section: id / columnsCount)) as! PuzzleGameCell
        cell.turn()

    }
    
    func gameDidEnd() {
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (t) in
            self.turnAll()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "gameEndViewController")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func turnCards(with firstId: Int, and secondId: Int) {
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (t) in
            self.turnCard(with: firstId)
            self.turnCard(with: secondId)
        }
    }
}


