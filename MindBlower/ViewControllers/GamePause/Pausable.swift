import UIKit

public protocol Pausable {
    var pauseStartTime: Date? {get set}
    var pauseView: PauseView! {get set}
}
