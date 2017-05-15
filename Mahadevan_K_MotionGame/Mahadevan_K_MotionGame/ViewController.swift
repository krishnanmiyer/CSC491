//
//  ViewController.swift
//  Mahadevan_K_MotionGame
//
//  Created by Krishnan Mahadevan on 5/13/17.
//  Copyright © 2017 Krishnan Mahadevan. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var ballCoordinates: UILabel!
    @IBOutlet weak var coordinates: UILabel!
    var circle = CircleView()
    let motionManager: CMMotionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        circle = CircleView(frame: CGRect(x: 40, y: 50, width: 40, height: 60))
        circle.backgroundColor = UIColor.clear
        view.addSubview(circle)
        coordinates.text = "H: \(self.view.bounds.height) - W: \(self.view.bounds.width)"
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
                
                self.ballCoordinates.text = "X: \(circleX) Y: \(circleY)"
                
                self.circle.moveCircle(x: CGFloat(Double(circleX) + (currentX * 50)), y: CGFloat(Double(circleY) + ((currentY * 50) * -2)))
                self.setNeedsFocusUpdate()
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
}

