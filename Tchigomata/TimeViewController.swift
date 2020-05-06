//
//  TimeViewController.swift
//  Tchigomata
//
//  Created by Yichen on 5/6/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit

import UIKit

class TimeViewController: UIViewController {

    var ud = UserDefaults.standard
            static var didExit = false
            static var screenOff = false
            
            let timeLeftShapeLayer = CAShapeLayer()
            let bgShapeLayer = CAShapeLayer()
            var timeLeft: TimeInterval = 10800
            var endTime: Date?
            var timeLabel =  UILabel()
            var timer = Timer()
            let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
            func drawBgShape() {
                bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
                    100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
                bgShapeLayer.strokeColor = UIColor.white.cgColor
                bgShapeLayer.fillColor = UIColor.clear.cgColor
                bgShapeLayer.lineWidth = 15
                view.layer.addSublayer(bgShapeLayer)
            }
            func drawTimeLeftShape() {
                timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
                    100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
                timeLeftShapeLayer.strokeColor = UIColor.red.cgColor
                timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
                timeLeftShapeLayer.lineWidth = 15
                view.layer.addSublayer(timeLeftShapeLayer)
            }
            func addTimeLabel() {
                timeLabel = UILabel(frame: CGRect(x: view.frame.midX-50 ,y: view.frame.midY-25, width: 100, height: 50))
                timeLabel.textAlignment = .center
                timeLabel.text = timeLeft.times
                view.addSubview(timeLabel)
            }
            override func viewDidLoad() {
                let gacha = ud.integer(forKey: "coins")
                ud.set(gacha, forKey: "coins")
                super.viewDidLoad()
                view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
                TimeViewController.didExit = false
                TimeViewController.screenOff = false
                drawBgShape()
                drawTimeLeftShape()
                addTimeLabel()
               
                strokeIt.fromValue = 0
                strokeIt.toValue = 1
//                strokeIt.duration = ud.value(forKey: 'now_duration')
                
                timeLeftShapeLayer.add(strokeIt, forKey: nil)
               
                endTime = Date().addingTimeInterval(timeLeft)
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TimeViewController.updateTime), userInfo: nil, repeats: true)
                CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), Unmanaged.passUnretained(self).toOpaque(), displayStatusChangedCallback, "com.apple.springboard.lockcomplete" as CFString, nil, .deliverImmediately)
            }
            @objc func updateTime() {
            var gachaCoins = ud.integer(forKey: "gacha")
            if TimeViewController.didExit {
                       resetPage()
                       if !TimeViewController.screenOff {
                           resetPage()
                           return
                       }
                   }
                
            if timeLeft > 0 {
                timeLeft = endTime?.timeIntervalSinceNow ?? 0
                timeLabel.text = timeLeft.times
                } else {
                timeLabel.text = "00:00"
                timer.invalidate()
                gachaCoins = gachaCoins + 3
                ud.set(gachaCoins, forKey: "gacha")
                print(gachaCoins)
                
                }
            }
        
        func resetPage() {
        timer.invalidate()
        timeLabel.text = "00:00:00"
            let alertController = UIAlertController(title: "You started to use your phone!", message: "Your time has been reset", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in print("canceled") }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true) {}
        }


        
    }

    

    private let displayStatusChangedCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
        guard let lockState = cfName?.rawValue as String? else {
            return
        }
        TimeViewController.screenOff = true
    }

