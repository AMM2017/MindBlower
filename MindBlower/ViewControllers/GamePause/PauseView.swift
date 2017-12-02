
import Foundation
import UIKit


public class PauseView: UIView {
    public var onExitPress: (() -> ())?
    public var onContinuePress: (() -> ())?

    var visualEffectView: UIVisualEffectView!
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        self.addSubview(visualEffectView)
        
        let xMargin = 20
        
        let backButton = UIButton(frame: CGRect(x: xMargin, y: 200, width: Int(UIScreen.main.bounds.width) - 2 * xMargin, height: 100))
        let exitButton = UIButton(frame: CGRect(x: xMargin, y: 330, width: Int(UIScreen.main.bounds.width) - 2 * xMargin, height: 100))
        
        let btnColor = UIColor(displayP3Red: 0.0, green: 97.0 / 255.0, blue: 175.0 / 255.0, alpha: 1)
        
        backButton.backgroundColor = btnColor
        backButton.setTitleColor(.white, for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        backButton.layer.cornerRadius = 15
        
        exitButton.backgroundColor = btnColor
        exitButton.setTitleColor(.white, for: .normal)
        exitButton.setTitle("Exit", for: .normal)
        exitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        exitButton.layer.cornerRadius = 15
        
        visualEffectView.contentView.addSubview(backButton)
        visualEffectView.contentView.addSubview(exitButton)
        
        backButton.addTarget(self, action: #selector(self.backButtonPress), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(self.exitButtonPress), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //typealias PausableVC = UIViewController & Pausable
    public func show(in vc: UIViewController & Pausable) {
        vc.view.addSubview(self)
        self.frame = vc.view.frame
        visualEffectView.frame = vc.view.frame
        self.center = vc.view.center
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations:  {
            self.alpha = 1
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
            self.transform = CGAffineTransform.identity
        })
    }

    
    func hide() {
        self.removeFromSuperview()
    }

    
    @objc func backButtonPress(sender: UIButton) {
        self.onContinuePress?()
        hide()
    }

    
    @objc func exitButtonPress(sender: UIButton) {
        self.onExitPress?()
        hide()
    }
}
