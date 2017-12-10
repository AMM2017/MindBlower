//
//  gameEndViewController.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 07.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import UIKit
import Alamofire

class GameEndViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var result: String = ""

    
    @IBAction func againBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okBtn(_ sender: Any) {
        self.navigationController!.popToViewController(navigationController!
            .viewControllers[navigationController!.viewControllers.count - 4], animated: true)
    }
    
    @IBAction func authorizationButtonPress(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "profileViewController__reuseId")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        resultLabel.text = result
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        VKSdk.wakeUpSession(SCOPE as! [Any]) { (state , error) in
//            if (state == VKAuthorizationState.authorized)
//            {
//                self.navigationController?.popViewController(animated: true)
//                return
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
