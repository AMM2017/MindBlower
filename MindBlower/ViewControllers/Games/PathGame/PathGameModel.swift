
import Foundation

class PathGameModel {
    var points = [PathGamePoint]()
    var path = [Int]()
    var currentPath = [Int]()
    
    var delegate: PathGameModelDelegate?
    
    enum difficulties: Int {
        case easy = 4
        case normal = 6
        case hard = 8
    }

    var pointsCount = 0
    var selectedPointsCount = 0
    
    init(difficulty: difficulties) {
        pointsCount = difficulty.rawValue
        selectedPointsCount = 0
        for i in 0..<pointsCount {
            points.append(PathGamePoint(id: i))
        }
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
                if path[i] != currentPath[i] {
                    delegate?.gameDidEnd(with: .lose)
                    return
                }
            }
            delegate?.gameDidEnd(with: .win)
        }
    }
}
