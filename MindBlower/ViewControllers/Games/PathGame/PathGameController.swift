
import UIKit

@available(iOS 10.0, *)
class PathGameController: UIViewController, Pausable, PathGameModelDelegate {
    
    var pauseView: PauseView!
    var pauseStartTime: Date?
    var showingStartTime: Date? = nil
    static var showingTime: Double = 3.0
    
    let leftMargin = 20
    let topMargin = 70
    
    var pathGameModel: PathGameModel! = nil
    
    let buttonSize = 20;
    var buttons: [UIButton] = []
    var coordinates = [CGPoint]()
    
    var path: UIBezierPath! = nil
    let pathLayer = CAShapeLayer()
    
    var totalPathLength: CGFloat = 0
    
    @IBAction func pauseButtonPress(_ sender: Any) {
        guard pauseView == nil else {
            return
        }
        
        pauseView = PauseView()
        
        guard let pauseView = pauseView else {
            return
        }
        pauseView.onContinuePress = {
            UIView.animate(withDuration: 0.3, animations: {
                self.pauseView.alpha = 0
                self.pauseView.visualEffectView.effect = nil
                self.pauseView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
            self.pauseView = nil
            self.continueGame()
        }
        
        pauseView.onExitPress = {
            self.navigationController!.popToViewController(self.navigationController!
                .viewControllers[self.navigationController!.viewControllers.count - 3], animated: true)
            self.pauseView = nil
        }
        
        pauseStartTime = Date()
        pauseView.show(in: self)
        
    }
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        pathGameModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PathGameController.showingTime = 3.0
        pathGameModel.startGame()
        genPointsCoordinates()
        createButtons()
        
        path = UIBezierPath(rect: self.view.bounds)
        pathLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        showingStartTime = Date()
        pauseStartTime = nil
        drawLine()
        
        Timer.scheduledTimer(withTimeInterval: PathGameController.showingTime + 1, repeats: false, block: {(t) in
            if self.pauseStartTime == nil {
                self.hideLines()
                for i in 0..<self.pathGameModel.pointsCount {
                    self.buttons[i].isEnabled = true
                }
            }
        })
        super.viewDidAppear(animated)
    }
    
    
    func genPointsCoordinates () {
        coordinates.removeAll()
        
        for i in 0...pathGameModel.pointsCount - 1 {

            var n = (Int(self.view.bounds.width) - 2 * leftMargin) / 2
            var fromValue = leftMargin + n * (i % 2)
            var toValue = fromValue + n
            
            let newX = Utils.getRandom(fromValue, toValue)

            n = (Int(self.view.bounds.height) - 2 * topMargin) * 2 / pathGameModel.pointsCount
            fromValue =  topMargin +  n * (i / 2)
            toValue = fromValue + n
            
            let newY = Utils.getRandom(fromValue, toValue)

            coordinates.append(CGPoint(x: newX, y: newY))
        }
    }
    
    func createButtons() {
        buttons.removeAll()
        for i in 0..<pathGameModel.pointsCount {
            let btn  = UIButton(frame: CGRect(x: Int(coordinates[i].x) - buttonSize / 2, y: Int(coordinates[i].y) - buttonSize / 2, width: buttonSize, height: buttonSize))
            
            btn.tag = i
            btn.addTarget(self, action: #selector(onButtonPress(sender:)), for: .touchUpInside)
            btn.isEnabled = false
            btn.backgroundColor = .blue
            btn.layer.cornerRadius = btn.layer.bounds.height / 2
            btn.layer.shadowRadius = 4.0
            btn.layer.shadowOpacity = 0.6
            btn.layer.shadowOffset = .zero
            
            buttons.append(btn)
            
            self.view.addSubview(buttons[i])
        }
    }
    
    @objc func onButtonPress(sender: UIButton){
        pathGameModel.selectPoint(with: sender.tag)
    }
    
    
    func onPointSelect() {
        if pathGameModel.selectedPointsCount > 1 {
            
            let point1 = coordinates[pathGameModel.currentPath[pathGameModel.selectedPointsCount - 2]]
            let point2 = coordinates[pathGameModel.currentPath[pathGameModel.selectedPointsCount - 1]]
            
            path.move(to: point1)
            path.addLine(to: point2)
            
            let currentLineLength = sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
            totalPathLength += currentLineLength
            
            setLayerSettings()
            
            pathLayer.path = path.cgPath
            
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = 1.0
            pathAnimation.fromValue = pathGameModel.selectedPointsCount != 2 ? 1 - currentLineLength / totalPathLength : 0
            pathAnimation.toValue =  1
            pathLayer.add(pathAnimation, forKey: "strokeEnd")
        }
        
    }
    
    func drawLine(from value: Double = 0, with duration: Double = showingTime) {
        path.removeAllPoints()
        path.move(to: coordinates[pathGameModel.path[0]])
        
        for i in 1...pathGameModel.pointsCount - 1 {
            path.addLine(to: coordinates[pathGameModel.path[i]])
        }
        view.layer.addSublayer(pathLayer)
        
        pathLayer.path = path.cgPath
        
        setLayerSettings()
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = duration
        pathAnimation.fromValue = value
        pathAnimation.toValue =  1
        pathLayer.add(pathAnimation, forKey: "strokeEnd")
        
        path.removeAllPoints()
    }
    
    func setLayerSettings() {
        pathLayer.strokeColor = UIColor.blue.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 3
        view.layer.addSublayer(pathLayer)
    }
    
    func hideLines() {
        pathLayer.removeFromSuperlayer()
    }
    
    var intervalsSum = 0.0
    
    func continueGame() {
        if showingStartTime != nil {
            let interval = pauseStartTime!.timeIntervalSince(showingStartTime!)
            intervalsSum += interval
            showingStartTime = Date()
            pauseStartTime = nil
            drawLine(from: intervalsSum / PathGameController.showingTime, with: PathGameController.showingTime - interval)
            PathGameController.showingTime = PathGameController.showingTime - interval
            
            Timer.scheduledTimer(withTimeInterval: interval + 1, repeats: false, block: {(t) in
                if self.pauseStartTime == nil {
                    self.hideLines()
                    for i in 0..<self.pathGameModel.pointsCount {
                        self.buttons[i].isEnabled = true
                        self.showingStartTime = nil
                        self.pauseStartTime = nil
                    }
                }
            })
        }
    }
    
    func gameDidEnd(with result: PathGameResult) {
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {(t) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "gameEndViewController") as! GameEndViewController
            
            switch result {
            case .lose:
                //showRightPath
                vc.result = "LOSE"
                
            case .win:
                vc.result = "WIN"
            }
            
            for i in 0..<self.pathGameModel.pointsCount {
                self.buttons[i].removeFromSuperview()
            }
            
            self.hideLines()
            
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}

