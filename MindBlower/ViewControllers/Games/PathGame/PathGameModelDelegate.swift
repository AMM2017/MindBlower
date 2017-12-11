
import Foundation

enum PathGameResult {
    case win
    case lose
}

protocol PathGameModelDelegate {
    func gameWasStarted()
    func onPointSelect()
    func gameDidEnd(with result: PathGameResult, score: Int)
    var pauseDuration: TimeInterval {get set} //??
}

extension PathGameModelDelegate {
    func gameWasStarted() {}
}

