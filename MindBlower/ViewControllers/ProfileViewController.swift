//
//  ProfileViewController.swift
//  MindBlower
//
//  Created by Kuroyan Juliett on 09.12.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import UIKit
import VK_ios_sdk.VKSdk
import NVActivityIndicatorView

class ProfileViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    let ACCESS_TOKEN = "access_token"
    let APP_ID = "6214742"
    var SCOPE: NSArray = []
    
    
    let loaderView = NVActivityIndicatorView(frame: accessibilityFrame(), type: .lineScale)
    
    @IBOutlet weak var AuthButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        if mbBackend.IsAuthenticated() {
            AuthButton.titleLabel?.text = "Logout"
            AuthButton.addTarget(self, action: #selector(self.authButtonPressIfAuthorized), for: .touchUpInside)
        } else {
            AuthButton.titleLabel?.text = "Authorize"
            AuthButton.addTarget(self, action: #selector(self.authButtonPressIfNotAuthorized), for: .touchUpInside)
        }
    }
    
    @objc func authButtonPressIfAuthorized() {
        mbBackend.logout()
    }

    @objc func authButtonPressIfNotAuthorized() {
        SCOPE = [VK_PER_EMAIL]
        loaderView.startAnimating()
        VKSdk.authorize(SCOPE as! [Any])
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if let vk_token = result.token {
            let credentials: [String: String] = [
                "provider": "vk",
                "email": vk_token.email!,
                "vk_token": vk_token.accessToken!
            ]
            mbBackend.ObtainToken(credentials: credentials, onSuccess: { (data: NSDictionary) in
                self.loaderView.stopAnimating()
                let alertController = UIAlertController(title: "Sign In", message: "Sign in succeded", preferredStyle: .alert)
                alertController.show(self, sender: nil)
            }, onFailure: { (data: NSDictionary) in
                self.loaderView.stopAnimating()
            })
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
    
    override func viewWillAppear(_ animated: Bool) {
        VKSdk.initialize(withAppId: APP_ID).register(self)
        VKSdk.instance().uiDelegate = self
    }
}
