//
//  gameEndViewController.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 07.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import UIKit

class GameEndViewController: UIViewController {
    
//    public let reuseID = "gameEndViewController"
    @IBOutlet weak var resultLabel: UILabel!
    
    var result: String = ""
    
    @IBAction func againBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okBtn(_ sender: Any) {
        self.navigationController!.popToViewController(navigationController!
            .viewControllers[navigationController!.viewControllers.count - 4], animated: true)
    }
    
    override func viewDidLoad() {
        resultLabel.text = result
    }
}
