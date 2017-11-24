//
//  PausePritocol.swift
//  pause
//
//  Created by Kuroyan Juliett on 23.11.17.
//  Copyright © 2017 C3G9. All rights reserved.
//

import Foundation
import UIKit

protocol PauseProtocol {
    var pauseButton: UIBarButtonItem! {get set}
    var delegateHandler: PauseProtocolDelegateHandler! {get set}
    var view: UIView! {get set}
    var navigationController: UINavigationController? {get}
}
