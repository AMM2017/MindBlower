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
    
    var loaderView:NVActivityIndicatorView? = nil
    
    @IBOutlet weak var AuthButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var circleLabel: UILabel!
    
    @IBAction func logoutBtnTouch(_ sender: Any) {
        mbBackend.logout()
        navigationController?.popViewController(animated: true)
    }
    
    func configure(for userInfo: UserInfo){
        nameLabel.text = "\(userInfo.firstName) \(userInfo.lastName)"
        emailLabel.text = userInfo.email
        circleLabel.text = "\(userInfo.firstName.prefix(1))\(userInfo.lastName.prefix(1))"
        
        // let firstNameLetters = "\(userInfo.firstName[0]) \(userInfo.lastName[0])"
        // TODO: Generate image with nice first name letters
        // Just like at github
    }
    
    func setControlsHiddeness(value: Bool){
        nameLabel.isHidden = value
        emailLabel.isHidden = value
        circleLabel.isHidden = value
        AuthButton.isHidden = value
    }
    
    func displayUserInfo(){
        setControlsHiddeness(value: true)
        mbBackend.getCurrentUserObject { userInfo in
            self.configure(for: userInfo)
            self.setControlsHiddeness(value: false)
            self.loaderView!.stopAnimating()
        }
    }
    
    func displayError(with message: String){
        self.loaderView!.stopAnimating()
        self.setControlsHiddeness(value: false)
        //TODO: Refactor this stuff
        self.nameLabel.isHidden = true
        self.circleLabel.isHidden = true
        self.AuthButton.isHidden = true
        self.emailLabel.text = message
    }
    
    func initLoader () {
        let width: CGFloat = 60.0
        let height: CGFloat = 60.0
        let x = view.frame.width / 2 - width / 2
        let y = view.frame.height / 2 - height / 2
    
        let frame = CGRect(x: x, y: y, width: width, height: height)
        loaderView = NVActivityIndicatorView(frame: frame, type: .ballSpinFadeLoader , color: UIColor.white)
    }
    
    override func viewDidLoad() {
        initLoader()
        view.addSubview(loaderView!)
        loaderView!.startAnimating()
        
        circleLabel.layer.masksToBounds = true
        circleLabel.layer.cornerRadius = circleLabel.bounds.width / 2
        
        if !mbBackend.isAuthenticated() {
            setControlsHiddeness(value: true)
            
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
            loaderView!.startAnimating()
            mbBackend.ObtainToken(credentials: credentials, onSuccess: { (data: NSDictionary) in
                self.displayUserInfo()
                VKSdk.forceLogout()
            }, onFailure: { (data: NSDictionary) in
                self.displayError(with: "Can't communicate with MindBlower server")
                VKSdk.forceLogout()
                //self.navigationController?.popViewController(animated: true) //TODO: Tell user that we've failed
            })
        }
        else{
            self.displayError(with: "Could not get VK credentials")
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        self.displayError(with: "Could not get VK credentials")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.navigationController?.topViewController?.present(controller, animated: true)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self.navigationController?.topViewController)
    }
}
