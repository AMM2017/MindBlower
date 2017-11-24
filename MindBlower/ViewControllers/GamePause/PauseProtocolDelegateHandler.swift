//
//  PauseProtocolDelegateHandler.swift
//  MindBlower
//
//  Created by Kuroyan Juliett on 23.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import Foundation
import UIKit

class PauseProtocolDelegateHandler : NSObject {
    var delegate: PauseProtocol!
    
    var pauseView: UIView!
    var visualEffectView: UIVisualEffectView!
    
    
    init(delegate: PauseProtocol) {
        super.init()
        self.delegate = delegate
        createPauseView()
        self.delegate.pauseButton.action = #selector(self.showPauseView)
        self.delegate.pauseButton.target = self
    }
    
    
    func createPauseView() {
        delegate.pauseButton.action = nil
        pauseView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        pauseView.addSubview(visualEffectView)
        
        let xMargin = 20
        
        let backButton = UIButton(frame: CGRect(x: xMargin, y: 200, width: Int(UIScreen.main.bounds.width) - 2 * xMargin, height: 100))
        let exitButton = UIButton(frame: CGRect(x: xMargin, y: 330, width: Int(UIScreen.main.bounds.width) - 2 * xMargin, height: 100))
        
        backButton.backgroundColor = .blue
        backButton.setTitleColor(.white, for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        backButton.layer.cornerRadius = 15
        
        exitButton.backgroundColor = .blue
        exitButton.setTitleColor(.white, for: .normal)
        exitButton.setTitle("Exit", for: .normal)
        exitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        exitButton.layer.cornerRadius = 15
        
        visualEffectView.contentView.addSubview(backButton)
        visualEffectView.contentView.addSubview(exitButton)
        
        delegate.view.addSubview(pauseView)
        pauseView.frame = delegate.view.frame
        visualEffectView.frame = delegate.view.frame
        pauseView.center = delegate.view.center
        pauseView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        pauseView.alpha = 0
        
        backButton.addTarget(self, action: #selector(self.backButtonPress), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(self.exitButtonPress), for: .touchUpInside)
    }
    
    
    @objc func showPauseView(sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.3, animations: {
            self.pauseView.alpha = 1
            self.visualEffectView.effect = UIBlurEffect(style: .light)
            self.pauseView.transform = CGAffineTransform.identity
        })
    }
    
    
    @objc func backButtonPress(sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.pauseView.alpha = 0
            self.visualEffectView.effect = nil
            self.pauseView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.delegate.pauseButton.action = #selector(self.showPauseView)
        })
    }
    
    
    @objc func exitButtonPress(sender: UIButton) {
        delegate.navigationController!.popToViewController(delegate.navigationController!
            .viewControllers[delegate.navigationController!.viewControllers.count - 3], animated: true)
    }
}
