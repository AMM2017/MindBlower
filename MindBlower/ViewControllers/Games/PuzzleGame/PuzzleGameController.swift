
import UIKit


@available(iOS 10.0, *)
class PuzzleGameController: UICollectionViewController, Pausable, PuzzleGameModelDelegate {
    
    var puzzleGameModel: PuzzleGameModel! = nil
    
    let cellReuseID = "puzzleGameCell_reuseId"
    var gameSpaceWidth = 0
    var gameSpaceHeight = 0
    var margin = 5
    
    var rowsCount = 0
    var columnsCount = 0
    
    let backImageId = 0
    
    static let showingTime = 5.0
    var showingStartTime: Date? = nil
    var pauseStartTime: Date? = nil

    var pauseView: PauseView!

    
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
        
        puzzleGameModel.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        puzzleGameModel.startGame()
        setImages()
        
        turnAll()
        showingStartTime = Date()
        pauseStartTime = nil
        
        Timer.scheduledTimer(withTimeInterval: PuzzleGameController.showingTime, repeats: false) { (t) in
            if (self.pauseStartTime == nil) {
                self.turnAll()
                self.showingStartTime = nil
                self.puzzleGameModel.startChooseCards()
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
    @IBAction func pauseButtonPress(_ sender: Any) {
        guard pauseView == nil else {
            return
        }
        
        pauseView = PauseView() 
        
        pauseView?.onContinuePress = {
            UIView.animate(withDuration: 0.3, animations: {
                self.pauseView.alpha = 0
                self.pauseView.visualEffectView.effect = nil
                self.pauseView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
            self.pauseView = nil
            self.continueGame()
        }
        
        pauseView?.onExitPress = {
            self.navigationController!.popToViewController(self.navigationController!
                .viewControllers[self.navigationController!.viewControllers.count - 3], animated: true)
            self.pauseView = nil
        }
        
        pauseStartTime = pauseView.show(in: self)
    }
    
    
    func continueGame() {
        if showingStartTime != nil {
            let interval = PuzzleGameController.showingTime - Double(pauseStartTime!.timeIntervalSince1970 - showingStartTime!.timeIntervalSince1970)
            pauseStartTime = nil
            showingStartTime = Date()
            Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { (t) in
                if self.pauseStartTime == nil {
                    self.turnAll()
                    self.puzzleGameModel.startChooseCards()
                    self.showingStartTime = nil
                    self.pauseStartTime = Date()
                }
            }
        }
    }
}


