
import UIKit

@available(iOS 10.0, *)
class PathGameController: UIViewController, Pausable, PathGameModelDelegate {
    
    var pathGameModel: PathGameModel! = nil
    var pauseView: PauseView!
    var pauseStartTime: Date?
    var showingStartTime: Date? = nil
    static var remainingShowingTime = 0.0
    let lineDrawingTime = 1.0

    let leftMargin = 20
    let topMargin = 70
    let buttonSize = 40;

    var buttons: [UIButton] = []
    var coordinates = [CGPoint]()
    
    var path: UIBezierPath! = nil
    let pathLayer = CAShapeLayer()
    
    var totalPathLength: CGFloat = 0
    var pausesCount = 0
    var pointsColor = UIColor(red: 43.0 / 255.0, green: 37.0 / 255.0, blue: 32.0 / 255.0, alpha: 1)
    
    var pauseDuration: TimeInterval = 0.0 

    @IBOutlet weak var pauseButton: UIBarButtonItem!
    @IBAction func pauseButtonPress(_ sender: Any) {
        
        self.pauseButton.isEnabled = false
        
        pausesCount += 1
        
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
            self.pauseButton.isEnabled = true
        }
        
        pauseView.onExitPress = {
            self.navigationController!.popToViewController(self.navigationController!
                .viewControllers[self.navigationController!.viewControllers.count - 3], animated: true)
            self.pauseView = nil
        }
        
        pauseStartTime = Date()
        
        if showingStartTime != nil {
            let pausedTime = pathLayer.convertTime(CACurrentMediaTime(), from: nil) //
            pathLayer.speed = 0.0
            pathLayer.timeOffset = pausedTime;
        }
        pauseView.show(in: self)
    }
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        pathGameModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pauseButton.isEnabled = true

        for i in 0..<self.pathGameModel.selectedPointsCount {
            self.buttons[i].removeFromSuperview()
        }
        
        self.hideLines()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        PathGameController.remainingShowingTime = pathGameModel.showingTime
        pathGameModel.startGame()
        genPointsCoordinates()
        createButtons()
        pausesCount = 0
        totalPathLength = 0
        pauseDuration = 0
        
        path = UIBezierPath(rect: self.view.bounds)
        pathLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        showingStartTime = Date()
        pauseStartTime = nil
        drawLines()
        
        Timer.scheduledTimer(withTimeInterval: PathGameController.remainingShowingTime + 1, repeats: false, block: {(t) in
            if (self.pauseStartTime == nil) && (self.pausesCount == 0) {
                self.hideLines()
                for i in 0..<self.pathGameModel.pointsCount {
                    self.buttons[i].isEnabled = true
                }
                self.showingStartTime = nil
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
            btn.backgroundColor = pointsColor
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
    
    var previousLineLenght: CGFloat = 0
    var lineDrawingStart = Date()
    
    func onPointSelect() {
        if pathGameModel.selectedPointsCount == pathGameModel.pointsCount {
            pauseButton.isEnabled = false
        }
        
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
            pathAnimation.duration = lineDrawingTime
            
            let k = Date().timeIntervalSince(lineDrawingStart) / lineDrawingTime
            
            var fromValue = 1 - currentLineLength / totalPathLength

            if k < 1 {
                fromValue -= previousLineLenght * (1 - CGFloat(k)) / totalPathLength
            }
            
            pathAnimation.fromValue = pathGameModel.selectedPointsCount != 2 ? fromValue : 0
            pathAnimation.toValue =  1
            
            lineDrawingStart = Date()
            
            pathLayer.add(pathAnimation, forKey: "strokeEnd")
            previousLineLenght = currentLineLength
        }
    }
    
    func drawLines(from startValue: Double = 0, to endValue: Double = 1, with duration: Double = remainingShowingTime) {
        path.removeAllPoints()
        path.move(to: coordinates[pathGameModel.path[0]])
        
        for i in 1..<pathGameModel.pointsCount {
            path.addLine(to: coordinates[pathGameModel.path[i]])
        }
        view.layer.addSublayer(pathLayer)
        
        pathLayer.path = path.cgPath
        
        setLayerSettings()
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = duration
        pathAnimation.fromValue = startValue
        pathAnimation.toValue =  endValue
        pathLayer.add(pathAnimation, forKey: "strokeEnd")
        
        path.removeAllPoints()
    }
    
    
    
    func setLayerSettings() {
        pathLayer.strokeColor = pointsColor.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 3
        pathLayer.lineJoin = kCALineJoinRound
        pathLayer.lineCap = kCALineJoinRound
//        pathLayer.lineDashPattern = [4, 4]
        view.layer.addSublayer(pathLayer)
    }
    
    func hideLines() {
        pathLayer.removeFromSuperlayer()
    }
    
    
    func continueGame() {
        guard let _ = pauseStartTime else {
            return
        }
        
        pauseDuration += Date().timeIntervalSince(pauseStartTime!)
                
        guard let _ = showingStartTime else {
            return
        }
        

        PathGameController.remainingShowingTime -= pauseStartTime!.timeIntervalSince(showingStartTime!)

        pauseStartTime = nil
        
        showingStartTime = Date()
        
        let pausedTime = pathLayer.timeOffset
        pathLayer.speed = 1.0;
        pathLayer.timeOffset = 0.0;
        pathLayer.beginTime = 0.0;
        let timeSincePause = pathLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime;
        pathLayer.beginTime = timeSincePause;
        
        let cnt = pausesCount
  
        Timer.scheduledTimer(withTimeInterval: PathGameController.remainingShowingTime + 1, repeats: false, block: {(t) in
            if (self.pauseStartTime == nil) && (cnt == self.pausesCount) {
                
                self.hideLines()
                for i in 0..<self.pathGameModel.pointsCount {
                    self.buttons[i].isEnabled = true
                    self.showingStartTime = nil
                    self.pauseStartTime = nil
                }
            }
        })
        
    }
    
    func gameDidEnd(with result: PathGameResult, score: Int = 0) {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {(t) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "gameEndViewController") as! GameEndViewController
        
            //-------------
            
            switch result {
            case .lose:
                vc.result = "LOSE"
                
            case .win:
                vc.result = "WIN"
            }

            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}

