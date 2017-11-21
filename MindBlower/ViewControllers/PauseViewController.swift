//
//  PauseViewController.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 07.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import UIKit

class PauseViewController: UIViewController {
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func exitBtn(_ sender: Any) {
        self.navigationController!.popToViewController(navigationController!
            .viewControllers[navigationController!.viewControllers.count - 4], animated: true)
    }
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
    }
}
