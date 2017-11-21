//
//  PuzzleGameController.swift
//  VKAuth
//
//  Created by Kuroyan Artur on 06.11.17.
//  Copyright © 2017 Kuroyan Artur. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class PathGameController: UIViewController {
    let leftMargin = 50
    let topMargin = 90
    
    @IBOutlet var pathGameView: UIView!
    
    @IBOutlet weak var pathGameImageView: UIImageView!
    
    var points: [CGPoint] = []
    var pointsCount: Int = 4
    let buttonSize = 16;
    var buttons: [UIButton] = []
    
    
    override func viewDidAppear(_ animated: Bool) {
        var i = 0;
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { (t) in
            self.drawLines(to: i)
            i += 1
            if (i == self.pointsCount-1) {
                t.invalidate()
            }
        }

        
        super.viewDidAppear(animated)
    }
    
    func genNewPoints () {
        points.removeAll()
        for _ in 1...pointsCount {
            let newX = Utils.getRandom(leftMargin, Int(pathGameView.bounds.width) - leftMargin)
            let newY = Utils.getRandom(topMargin, Int(pathGameView.bounds.height) - topMargin)
            points.append(CGPoint(x: newX, y: newY))
        }
    }
    
    func createButtons() {
        for i in 0...pointsCount-1 {
            let btn  = UIButton(frame: CGRect(x: Int(points[i].x) - buttonSize / 2, y: Int(points[i].y) - buttonSize / 2, width: buttonSize, height: buttonSize))
            buttons.append(btn)
            buttons[i].backgroundColor = UIColor.blue
            buttons[i].layer.cornerRadius = buttons[i].layer.bounds.height / 2
            pathGameImageView.addSubview(buttons[i])
            
        }
    }
    
    
    func drawLine(from point1: CGPoint, to point2: CGPoint, context: CGContext?) {
        context?.move(to: point1)
        context?.addLine(to: point2)
    }
    
    
    func drawLines(to num: Int) {
        UIGraphicsBeginImageContext(view.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(CGFloat(3))
        
        for i in 0...num {
            drawLine(from: points[i], to: points[i+1], context: context)
        }
        
        context?.strokePath()
        
        pathGameImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        pathGameImageView.alpha = 1.0
        UIGraphicsEndImageContext()
    }
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        genNewPoints()
        createButtons()
    }
}
