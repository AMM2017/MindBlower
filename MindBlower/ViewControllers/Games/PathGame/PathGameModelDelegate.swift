
import Foundation

enum PathGameResult {
    case win
    case lose
}

protocol PathGameModelDelegate {
    func gameWasStarted()
    func onPointSelect()
    func gameDidEnd(with result: PathGameResult)
}

extension PathGameModelDelegate {
    func gameWasStarted() {}
}

