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
    
    
    let loaderView = NVActivityIndicatorView(frame: accessibilityFrame(), type: .lineScale, color: UIColor.white)
    
    @IBOutlet weak var AuthButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var circleLabel: UILabel!
    
    func configure(for userInfo: UserInfo){
        nameLabel.text = "\(userInfo.firstName) \(userInfo.lastName)"
        emailLabel.text = userInfo.email
        circleLabel.text = "\(userInfo.firstName.prefix(1))\(userInfo.lastName.prefix(1))"
        
        // let firstNameLetters = "\(userInfo.firstName[0]) \(userInfo.lastName[0])"
        // TODO: Generate image with nice first name letters
        // Just like at github
    }
    
    func displayUserInfo(){
        view.isHidden = true
        mbBackend.getCurrentUserObject { userInfo in
            self.configure(for: userInfo)
            self.view.isHidden = false;
        }
    }
    
    override func viewDidLoad() {
        circleLabel.layer.masksToBounds = true
        circleLabel.layer.cornerRadius = circleLabel.bounds.width / 2
        if !mbBackend.isAuthenticated() {
            view.isHidden = true
            
            VKSdk.initialize(withAppId: APP_ID).register(self)
            VKSdk.instance().uiDelegate = self
            SCOPE = [VK_PER_EMAIL]
            VKSdk.authorize(SCOPE as! [Any])
        }
        else {
            displayUserInfo()
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if let vk_token = result.token {
            let credentials: [String: String] = [
                "provider": "vk",
                "email": vk_token.email!,
                "vk_token": vk_token.accessToken!
            ]
            loaderView.startAnimating()
            mbBackend.ObtainToken(credentials: credentials, onSuccess: { (data: NSDictionary) in
                self.loaderView.stopAnimating()
                self.displayUserInfo()
            }, onFailure: { (data: NSDictionary) in
                self.navigationController?.popViewController(animated: true) //TODO: Tell user that we've failed
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
        
    }
}
