//
//  gameEndViewController.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 07.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import VK_ios_sdk.VKSdk
import UIKit
import Alamofire

class GameEndViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate  {
    
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
        SCOPE = [VK_PER_EMAIL]
        VKSdk.authorize(SCOPE as! [Any])
    }
    
    
    override func viewDidLoad() {
        resultLabel.text = result
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()
    }

    
    let ACCESS_TOKEN = "access_token"
    let APP_ID = "6214742"
    var SCOPE: NSArray = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VKSdk.initialize(withAppId: APP_ID).register(self)
        VKSdk.instance().uiDelegate = self
        
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
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if let vk_token = result.token {
            let credentials: [String: String] = [
                "provider": "vk",
                "email": vk_token.email!,
                "vk_token:": vk_token.accessToken!
            ]
            credentialManager.ObtainToken(credentials: credentials, onSuccess: { (Any) in
                self.navigationController?.popViewController(animated: true)
            }, onFailure: { (Any) in
                let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                alert.show(self, sender: nil)
            })
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        self.navigationController?.popToRootViewController(animated: true)
        //
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.navigationController?.topViewController?.present(controller, animated: true)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self.navigationController?.topViewController)
    }
}
