import Foundation

class PathGameModel {
    var points = [PathGamePoint]()
    var path = [Int]()
    var currentPath = [Int]()
    
    let showingTime = 3.0

    var delegate: PathGameModelDelegate?
    
    enum difficulties: Int {
        case easy = 4
        case normal = 6
        case hard = 8
    }

    var pointsCount = 0
    var selectedPointsCount = 0
    var gameStartTime: Date? = nil
    var correctlySelectedPointsCount = 0
    
    init(difficulty: difficulties) {
        pointsCount = difficulty.rawValue
        selectedPointsCount = 0
        for i in 0..<pointsCount {
            points.append(PathGamePoint(id: i))
        }
        correctlySelectedPointsCount = 0
    }
    
    func genPath() {
        path.removeAll()
        
        var idArray = [Int]()
        
        for i in 0..<pointsCount {
            idArray.append(i)
        }
        
        
        for _ in 0..<pointsCount {
            let n = Utils.getRandom(0, idArray.count - 1)
            let pointId = idArray[n]
            idArray.remove(at: n)
            path.append(pointId)
        }
    }
    
    func startGame() {
        delegate?.gameWasStarted()
        selectedPointsCount = 0
        genPath()
        currentPath.removeAll()
        gameStartTime = Date()
        
        print("Start \(String(describing: gameStartTime))")
    }
    
    func selectPoint(with id: Int) {
        if points[id].isSelected {
            return
        }
        
        points[id].select()
        currentPath.append(id)
        selectedPointsCount += 1
        
        delegate?.onPointSelect()
        
        if selectedPointsCount == pointsCount {

            for i in 0..<pointsCount {
                points[i].unselect()
            }

            for i in 0..<pointsCount {
                if path[i] == currentPath[i] {
                    correctlySelectedPointsCount += 1
                }
            }
            
            let gameResult = correctlySelectedPointsCount == pointsCount ?
                PathGameResult.win :
                PathGameResult.lose
            
            
            guard let startTime = gameStartTime else {
                fatalError("") //
            }
            
            var gameDuration = Date().timeIntervalSince(startTime) - showingTime
            
            if let pauseDuration = delegate?.pauseDuration {
                gameDuration -= pauseDuration
            }
            
            let score = correctlySelectedPointsCount * Int(100.0 / gameDuration) //
            
            delegate?.gameDidEnd(with: gameResult, score: score)
        }
    }
}
