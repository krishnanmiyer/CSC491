//
//  ViewController.swift
//  Mahadevan_K_MotionGame
//
//  Created by Krishnan Mahadevan on 5/4/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var coordinates: UILabel!
    weak var blockTimer: Timer?
    var circle = CircleView()
    
    let greenPoints: Int = 10
    let redPoints:Int = -5
    var userScore: Int = 0
    
    let motionManager: CMMotionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        circle = CircleView(frame: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 40, height: 60))
        circle.backgroundColor = UIColor.clear
        view.addSubview(circle)
        
        blockTimer = Timer.scheduledTimer(timeInterval: 3 , target: self, selector: #selector(self.dropBlock), userInfo: nil, repeats: true)
        
        coordinates.text = "\(ScoreBoard.sharedInstance.score)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        motionManager.accelerometerUpdateInterval = 0.1;
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let acceleration = data?.acceleration {
                let currentX = acceleration.x
                let currentY = acceleration.y
                var circleX = self.circle.x
                var circleY = self.circle.y
                
                if (circleX < 15) {
                    circleX = CGFloat(15)
                }
                else if (circleX > self.view.bounds.width - 60)  {
                    circleX = self.view.bounds.width - 60
                }
                
                if (circleY < 15) {
                    circleY = CGFloat(15)
                }
                else if (circleY > self.view.bounds.height - 80)  {
                    circleY = self.view.bounds.height - 80
                }
                
                self.circle.moveCircle(x: CGFloat(Double(circleX) + (currentX * 50)), y: CGFloat(Double(circleY) + ((currentY * 50) * -2)))
                
                self.lock(obj: self.view.subviews as AnyObject) {
                    self.detectCollision()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if motionManager.isAccelerometerAvailable {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @objc private func dropBlock() {
        
        DispatchQueue.main.async {
            // set up some constants for the animation
            let duration = TimeInterval(arc4random_uniform(3) + 2)
            let delay = 0.0
            let options = UIViewAnimationOptions.curveLinear
            let size : CGFloat = 30
            let yPosition : CGFloat = CGFloat( arc4random_uniform(UInt32(self.view.bounds.height - 100) + 80))
            let maxWidth = self.view.bounds.width
            
            let coloredSquare = BlockView()
            coloredSquare.frame = CGRect(x: 40, y: yPosition, width: size, height: size)
            
            if (arc4random_uniform(200) % 2 == 0) {
                coloredSquare.backgroundColor =  UIColor.green
                coloredSquare.tag = self.greenPoints
            }
            else {
                coloredSquare.backgroundColor =  UIColor.red
                coloredSquare.tag = self.redPoints
            }
            
            self.view.addSubview(coloredSquare)
            
            // define the animation
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
                coloredSquare.frame = CGRect(x: maxWidth - size, y: yPosition, width: size, height: size)
                
            }, completion: { animationFinished in
                coloredSquare.removeFromSuperview()
            }
            )
        }
    }
    
    private func detectCollision() {
        for view in self.view.subviews.lazy.flatMap({ $0 as? BlockView }) {
            if self.circle.frame.intersects(view.frame) {
                view.accept(visitor: circle)
                DispatchQueue.main.async {
                    self.coordinates.text = "\(ScoreBoard.sharedInstance.score)"
                }
                return
            }
        }
    }
    
    func lock(obj: AnyObject, blk:() -> ()) {
        objc_sync_enter(obj)
        blk()
        objc_sync_exit(obj)
    }
    
    private func updateScore(points: Int) {
        userScore += points
    }
}

