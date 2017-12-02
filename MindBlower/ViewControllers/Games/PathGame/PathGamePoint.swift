
import Foundation

class PathGamePoint {
    private var id: Int
    private var state: PathGamePointState
    
    init(id: Int, state: PathGamePointState = .notSelected) {
        self.id = id
        self.state = state
    }
    
    func select() {
        state = .selected
    }
    
    func unselect() {
        state = .notSelected
    }
    
    var isSelected: Bool {
        return state == .selected
    }
}
