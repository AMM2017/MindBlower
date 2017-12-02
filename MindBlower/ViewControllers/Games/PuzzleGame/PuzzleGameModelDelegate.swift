
protocol PuzzleGameModelDelegate {
    func gameWasStarted()
    func turnCard(with id: Int)
    func turnCards(with firstId: Int, and secondId: Int)
    func gameDidEnd()
}

// Protocol Oriented Programming
extension PuzzleGameModelDelegate {
    func gameWasStarted() {}
}
