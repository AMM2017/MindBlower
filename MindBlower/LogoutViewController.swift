////
////  LogoutViewController.swift
////  VKAuth
////
////  Created by Kuroyan Artur on 10.10.17.
////  Copyright © 2017 Kuroyan Artur. All rights reserved.
////
//
//import UIKit
//import VK_ios_sdk.VKSdk
//
//class LogoutViewController: UIViewController {
//    @IBOutlet weak var IDLabel: UILabel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "logout", style: UIBarButtonItemStyle.done, target: self, action: #selector(logout(sender:)))
//        IDLabel.text = "User ID: " + VKSdk.accessToken().userId + "\n" + VKSdk.accessToken().localUser.first_name + " " + VKSdk.accessToken().localUser.last_name
//    }
//
//    @objc func logout(sender: UIBarButtonItem) {
//        VKSdk.forceLogout()
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//}

