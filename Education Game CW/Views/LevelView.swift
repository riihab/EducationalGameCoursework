//
//  LevelView.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 11/12/2023.
//

import Foundation
import UIKit
import CoreMotion

class LevelView : UIView {
    
    var hasLayoutSubviewsBeenCalled = false
    var layoutSubviewsCompletion: (() -> Void)?
    
    var pauseButton = UIButton()
    
    var title = UILabel()
    var totalTimeLabel = UILabel()
    var scoreLabel = UILabel()
    
    var leftButton = UIButton()
    var rightButton = UIButton()
    
    var leftAnswerLabel = UILabel()
    var rightAnswerLabel = UILabel()
    
    var repeatedLabel = UILabel()
    
    var animator: UIDynamicAnimator!
    var balls: [UIView] = []
    let gravity = UIGravityBehavior()
    let collision = UICollisionBehavior()
    let motionManager = CMMotionManager()
    
    let shapeLayer = CAShapeLayer()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        title.layer.backgroundColor = UIColor.white.withAlphaComponent(0.9).cgColor
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 1
        title.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        title.layer.borderWidth = 5
        addSubview(title)
        
        totalTimeLabel.textAlignment = .center
        totalTimeLabel.adjustsFontSizeToFitWidth = true
        totalTimeLabel.numberOfLines = 1
        addSubview(totalTimeLabel)
        
        scoreLabel.textAlignment = .center
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.numberOfLines = 1
        //        scoreLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.9).cgColor
        //        scoreLabel.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        //        scoreLabel.layer.borderWidth = 5
        addSubview(scoreLabel)
        
        leftButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        leftButton.tintColor = .black.withAlphaComponent(1)
        leftButton.isEnabled = true
        leftButton.isExclusiveTouch = true
        leftButton.adjustsImageWhenHighlighted = false
        leftButton.imageView?.contentMode = .scaleAspectFit
        leftButton.contentHorizontalAlignment = .center
        leftButton.titleLabel?.adjustsFontSizeToFitWidth = true
        leftButton.titleLabel?.numberOfLines = 1
        leftButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        leftButton.layer.borderWidth = 5
        leftButton.tag = 1
        addSubview(leftButton)
        leftButton.accessibilityElementsHidden = true
        
        rightButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        rightButton.tintColor = .black.withAlphaComponent(1)
        rightButton.isEnabled = true
        rightButton.isExclusiveTouch = true
        rightButton.adjustsImageWhenHighlighted = false
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.contentHorizontalAlignment = .center
        rightButton.titleLabel?.adjustsFontSizeToFitWidth = true
        rightButton.titleLabel?.numberOfLines = 1
        rightButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        rightButton.layer.borderWidth = 5
        rightButton.tag = 2
        addSubview(rightButton)
        rightButton.accessibilityElementsHidden = true
        
        //        pauseButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        pauseButton.tintColor = .black.withAlphaComponent(1)
        pauseButton.isEnabled = true
        pauseButton.isExclusiveTouch = true
        pauseButton.adjustsImageWhenHighlighted = false
        pauseButton.imageView?.contentMode = .scaleAspectFit
        pauseButton.contentHorizontalAlignment = .center
        pauseButton.titleLabel?.adjustsFontSizeToFitWidth = true
        pauseButton.titleLabel?.numberOfLines = 1
        //        pauseButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        //        pauseButton.layer.borderWidth = 5
        addSubview(pauseButton)
        pauseButton.accessibilityLabel = "Pause"
        
        leftAnswerLabel.textAlignment = .center
        leftAnswerLabel.adjustsFontSizeToFitWidth = true
        leftAnswerLabel.numberOfLines = 1
        addSubview(leftAnswerLabel)
        
        rightAnswerLabel.textAlignment = .center
        rightAnswerLabel.adjustsFontSizeToFitWidth = true
        rightAnswerLabel.numberOfLines = 1
        addSubview(rightAnswerLabel)
        
        repeatedLabel.layer.backgroundColor = UIColor.clear.cgColor //.white.withAlphaComponent(0.9).cgColor
        repeatedLabel.textAlignment = .center
        repeatedLabel.adjustsFontSizeToFitWidth = true
        repeatedLabel.numberOfLines = 1
        repeatedLabel.layer.borderColor = UIColor.clear.cgColor //.white.withAlphaComponent(0.5).cgColor
        repeatedLabel.layer.borderWidth = 5
        addSubview(repeatedLabel)
        repeatedLabel.alpha = 0
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLayoutSubviewsBeenCalled {
            hasLayoutSubviewsBeenCalled = true
            
            let height = superview?.frame.height ?? 0
            let width = superview?.frame.width ?? 0
            
            // Set up animator and behaviors
            animator = UIDynamicAnimator(referenceView: self)
            animator.addBehavior(gravity)
            animator.addBehavior(collision)
            // Start motion updates
            startMotionUpdates()
            
            let question = " "
            title.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.125)
            title.center.x = self.bounds.width*0.5
            title.center.y = self.bounds.height*0.3
            title.layer.cornerRadius = self.bounds.height*0.03125
            let attributeTitle = Attribute.outline(string: "\(question)", font: FontKit.roundedFont(ofSize: self.bounds.height*0.075, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            title.attributedText = attributeTitle
            
            let time = 60
            totalTimeLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.2, height: self.bounds.height*0.1)
            totalTimeLabel.center.x = self.bounds.width*0.825
            totalTimeLabel.center.y = self.bounds.height*0.15
            let attributeTime = Attribute.outline(string: "\(time)", font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .white)
            totalTimeLabel.attributedText = attributeTime
            
            scoreLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.6, height: self.bounds.height*0.1)
            scoreLabel.center.x = self.bounds.width*0.5
            scoreLabel.center.y = self.bounds.height*0.15
            let imageAttachment = NSTextAttachment()
            let imageConfiguration = UIImage.SymbolConfiguration(font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .semibold))
            imageAttachment.image = UIImage(systemName: "trophy.fill", withConfiguration: imageConfiguration)?.withTintColor(.systemYellow.withAlphaComponent(0.9))
            let fullString = NSMutableAttributedString(attachment: imageAttachment)
            fullString.append(Attribute.outline(string: " 0", font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .heavy), outlineSize: 0, textColor: .black, outlineColor: .white))
            scoreLabel.attributedText = fullString
            
            leftButton.frame = CGRect(x: 0, y: 0, width: width*0.4, height: height*0.15)
            leftButton.center.x = width*0.18
            leftButton.center.y = height*0.75
            leftButton.layer.cornerRadius = self.bounds.height*0.03125 // 0.0225
            leftButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            
            rightButton.frame = CGRect(x: 0, y: 0, width: width*0.4, height: height*0.15)
            rightButton.center.x = width*0.82
            rightButton.center.y = height*0.75
            rightButton.layer.cornerRadius = self.bounds.height*0.03125 // 0.0225
            rightButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            
            let leftAnswer = " "
            leftAnswerLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.2, height: self.bounds.height*0.1)
            leftAnswerLabel.center.x = self.bounds.width*0.2
            leftAnswerLabel.center.y = self.bounds.height*0.75
            let attributeLeft = Attribute.outline(string: "\(leftAnswer)", font: FontKit.roundedFont(ofSize: self.bounds.height*0.075, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .white)
            leftAnswerLabel.attributedText = attributeLeft
            
            let rightAnswer = " "
            rightAnswerLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.2, height: self.bounds.height*0.1)
            rightAnswerLabel.center.x = self.bounds.width*0.8
            rightAnswerLabel.center.y = self.bounds.height*0.75
            let attributeRight = Attribute.outline(string: "\(rightAnswer)", font: FontKit.roundedFont(ofSize: self.bounds.height*0.075, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .white)
            rightAnswerLabel.attributedText = attributeRight
            
            pauseButton.frame = CGRect(x: 0, y: 0, width: width*0.2, height: height*0.1)
            pauseButton.center.x = width*0.125
            pauseButton.center.y = height*0.15
            let leftImageConfig2 = UIImage.SymbolConfiguration(pointSize: (width*0.1), weight: .heavy, scale: .large)
            let leftImage2 = UIImage(systemName: "pause.rectangle.fill", withConfiguration: leftImageConfig2)
            pauseButton.setImage(leftImage2, for: .normal)
            
            repeatedLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.075)
            repeatedLabel.center.x = self.bounds.width*0.5
            repeatedLabel.center.y = self.bounds.height*0.4
            repeatedLabel.layer.cornerRadius = self.bounds.height*0.03125
            let attributeTitle2 = Attribute.outline(string: "REPEATED QUESTION", font: FontKit.roundedFont(ofSize: self.bounds.height*0.0375, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            repeatedLabel.attributedText = attributeTitle2
            
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width*0.825, y: self.bounds.height*0.15), // CGPoint(x: self.bounds.width*0.85, y: self.bounds.height*0.15)
                                            radius: self.bounds.height*0.05,
                                            startAngle: -CGFloat.pi / 2,
                                            endAngle: 2 * CGFloat.pi,
                                            clockwise: true)
            
            // Setup shape layer
            shapeLayer.path = circularPath.cgPath
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.lineWidth = self.bounds.height*0.0125
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineCap = .round
            shapeLayer.strokeEnd = 1
            layer.addSublayer(shapeLayer)
            
            collision.addBoundary(withIdentifier: "boxBoundary" as NSCopying, for: UIBezierPath(rect: self.frame))
            collision.addBoundary(withIdentifier: "boxBoundary2" as NSCopying, for: UIBezierPath(rect: title.frame))
            collision.addBoundary(withIdentifier: "boxBoundary3" as NSCopying, for: UIBezierPath(rect: leftButton.frame))
            collision.addBoundary(withIdentifier: "boxBoundary4" as NSCopying, for: UIBezierPath(rect: rightButton.frame))
            
            layoutSubviewsCompletion?()
        }
        
    }
    
    // change the timer based on the new time
    @objc func reduceTime(newTime: Int) {
        let percentageComplete : Double = Double(Double(Double(newTime) / 75.0)) // Double(1 - Double(Double(newTime) / 61.0))
        shapeLayer.strokeEnd = CGFloat(percentageComplete)
        
        let attributeTime = Attribute.outline(string: "\(newTime)", font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .white)
        totalTimeLabel.attributedText = attributeTime
        totalTimeLabel.accessibilityLabel = "\(newTime) seconds remaining"
    }
    
    // add new ball with gravity and collision
    @objc func addBall() {
        let ball = UIView()
        ball.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.15, height: self.bounds.width*0.15)
        ball.center.x = self.bounds.width*0.5
        ball.center.y = self.bounds.height*0.5
        ball.backgroundColor = UIColor.systemYellow.withAlphaComponent(1) // UIColor(hue: CGFloat.random(in: 0...1), saturation: CGFloat.random(in: 0.8...1.0), brightness: CGFloat.random(in: 0.8...1), alpha: 1)
        ball.layer.cornerRadius = self.bounds.width*0.075
        ball.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        ball.layer.borderWidth = 5
        addSubview(ball)
        balls.append(ball)
        ball.accessibilityElementsHidden = true
        
        for ball in balls {
            gravity.addItem(ball)
            collision.addItem(ball)
        }
    }
    
    // begin recognising motion
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
                guard let motion = motion else { return }
                self?.applyDeviceMotion(motion)
            }
        }
    }
    
    // changing gravity based on rotation/motion
    func applyDeviceMotion(_ motion: CMDeviceMotion) {
        let gravityX = motion.gravity.x
        let gravityY = motion.gravity.y
        gravity.gravityDirection = CGVector(dx: gravityX, dy: -gravityY)
    }
    
    // updating the question and answers
    @objc func updateText(titleText: String, leftText: String, rightText: String, isRepeatedQuestion: Bool) {
        title.text = titleText
        leftAnswerLabel.text = leftText
        rightAnswerLabel.text = rightText
        repeatedLabel.alpha = (isRepeatedQuestion ?  1 : 0)
        
        title.accessibilityLabel = titleText
        leftAnswerLabel.accessibilityLabel = leftText
        rightAnswerLabel.accessibilityLabel = rightText
    }
    
    // when tapping correct answer
    @objc func correctAnimation(isRight: Bool, score: Int, isCoinsOn: Bool) {
        rightButton.isEnabled = false
        leftButton.isEnabled = false
        if isRight == true {
            rightAnimation()
        } else {
            leftAnimation()
        }
        
        if isCoinsOn == true {
            addBall()
        }
        
        let imageAttachment = NSTextAttachment()
        let imageConfiguration = UIImage.SymbolConfiguration(font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .semibold))
        imageAttachment.image = UIImage(systemName: "trophy.fill", withConfiguration: imageConfiguration)?.withTintColor(.systemYellow.withAlphaComponent(0.9))
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        fullString.append(Attribute.outline(string: " \(score)", font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .heavy), outlineSize: 0, textColor: .black, outlineColor: .white))
        scoreLabel.attributedText = fullString
        scoreLabel.accessibilityLabel = "\(score) points"
    }
    
    // when tapping incorrect answer
    @objc func incorrectAnimation(isRight: Bool) {
        rightButton.isEnabled = false
        leftButton.isEnabled = false
        if isRight == true {
            rightAnimation()
        } else {
            leftAnimation()
        }
    }
    
    // animation when tapping right answer button
    @objc func rightAnimation() {
        self.bringSubviewToFront(rightAnswerLabel)
        self.insertSubview(rightButton, belowSubview: rightAnswerLabel)
        UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
            //            self.rightButton.transform = CGAffineTransform(scaleX: 10.0, y: 10.0) // CGAffineTransform.identity
            self.rightButton.backgroundColor = UIColor.white.withAlphaComponent(1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
                self.rightButton.transform = CGAffineTransform.identity
                self.rightButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            }, completion: { _ in
                self.rightButton.isEnabled = true
                self.leftButton.isEnabled = true
            })
        })
    }
    
    // animation when tapping left answer button
    @objc func leftAnimation() {
        self.bringSubviewToFront(leftAnswerLabel)
        self.insertSubview(leftButton, belowSubview: leftAnswerLabel)
        UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
            //            self.leftButton.transform = CGAffineTransform(scaleX: 10.0, y: 10.0) // CGAffineTransform.identity
            self.leftButton.backgroundColor = UIColor.white.withAlphaComponent(1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
                self.leftButton.transform = CGAffineTransform.identity
                self.leftButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            }, completion: { _ in
                self.rightButton.isEnabled = true
                self.leftButton.isEnabled = true
            })
        })
    }
    
    // creates the background animation
    @objc func backgroundAnimation(currentLevel: Int) {
        
        for view in self.subviews {
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
        
        var symbol = ["plus.circle.fill", "minus.circle.fill", "multiply.circle.fill", "divide.circle.fill"]
        switch currentLevel {
        case 1: symbol = ["plus.circle.fill"]
        case 2: symbol = ["minus.circle.fill"]
        case 3: symbol = ["multiply.circle.fill"]
        case 4: symbol = ["divide.circle.fill"]
        default: print("Unknown Level")
        }
        
        for i in -1...25 {
            for j in -1...10 {
                let backgroundButton = UIButton()
                backgroundButton.frame = CGRect(x: self.bounds.width*0.15*CGFloat(j) - self.bounds.width*0.2,
                                                y: self.bounds.width*0.15*CGFloat(i) - self.bounds.width*0.2,
                                                width: self.bounds.width*0.2,
                                                height: self.bounds.width*0.2)
                let configuration = UIImage.SymbolConfiguration(pointSize: CGFloat(self.bounds.width*0.1), weight: .black, scale: .large)
                let image = UIImage(systemName: "\(symbol.randomElement() ?? "")", withConfiguration: configuration)?
                    .withTintColor(UIColor(hue: CGFloat(Double.random(in: 0.0...0.0)),
                                           saturation: CGFloat(Double.random(in: 0...0)),
                                           brightness: CGFloat(Double.random(in: 1...1)), alpha: 1).withAlphaComponent(1),
                                   renderingMode: .alwaysOriginal)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = image
                let imageString = NSAttributedString(attachment: imageAttachment)
                backgroundButton.setAttributedTitle(imageString, for: .normal)
                addSubview(backgroundButton)
                backgroundButton.tag = 999
                backgroundButton.alpha = 0.0
                sendSubviewToBack(backgroundButton)
                backgroundButton.accessibilityElementsHidden = true
                
                UIView.animate(withDuration: TimeInterval(Double.random(in: 1.0...2.0)),
                               delay: TimeInterval(Double(i+2)/10),
                               usingSpringWithDamping: 100, initialSpringVelocity: 0,
                               options: [.allowAnimatedContent, .autoreverse, .transitionFlipFromRight, .repeat], animations: {
                    backgroundButton.alpha = 0.25
                }, completion: nil)
            }
        }
    }
    
    // stops the background animation
    @objc func stopBackgroundAnimation() {
        for view in self.subviews {
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
    }
    
    // when canceling a button press
    @objc func buttonExit(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // when pressing a button
    @objc func buttonDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
        }, completion: nil)
    }
    
}
