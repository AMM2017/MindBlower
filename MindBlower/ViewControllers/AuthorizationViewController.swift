//
//  ViewController.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 10.10.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import UIKit
import VK_ios_sdk.VKSdk


class ViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {

    let ACCESS_TOKEN = "access_token"
    let APP_ID = "6214742"
//    let SEGUE_AUTHORIZED = "authorized"
    var SCOPE: NSArray = []
    
    
    @IBOutlet weak var authState: UILabel!
    
    
    override func viewDidLoad() {
        if #available(iOS 10.0, *) {
            tabBarController?.tabBar.barTintColor = UIColor(displayP3Red: 0, green: 194.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VKSdk.initialize(withAppId: APP_ID).register(self)
        VKSdk.instance().uiDelegate = self
        
        VKSdk.wakeUpSession(SCOPE as! [Any]) { (state , error) in
            if (state == VKAuthorizationState.authorized)
            {
                self.startWork()
                return
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startWork() {
//        self.performSegue(withIdentifier: SEGUE_AUTHORIZED, sender: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if let _ = result.token {
            self.startWork()
            return
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.navigationController?.topViewController?.present(controller, animated: true)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self.navigationController?.topViewController)
    }

    @IBAction func AuthButton(_ sender: Any) {
        SCOPE = [VK_PER_EMAIL]
        VKSdk.authorize(SCOPE as! [Any])
    }
}

