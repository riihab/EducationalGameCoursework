//
//  GameOverViewController.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 11/12/2023.
//

import Foundation
import UIKit
import CoreMotion

class GameOverViewController: UIViewController  {
    
    var firebaseDatabase = FirebaseDatabase()
    
    var gameOverView = GameOverView()
    
    var currentLevel: Int?
    var currentDifficulty: Int?
    
    var score: Int?
    var wrongAnswerCount: Int?
    
    var highscore = 0
    
    var defaults = UserDefaults.standard
    var highArray : [Double] = []
    var wrongArray : [Double] = []
    
    var themeColour = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        firebaseDatabase.configureDatabase()
        
        view.backgroundColor = UIColor.white
        
        gameOverView = GameOverView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        gameOverView.center.x = view.bounds.width*0.5
        gameOverView.center.y = view.bounds.height*0.5
        gameOverView.alpha = 0
        view.addSubview(gameOverView)
        
        //        self.defaults.register(defaults: ["themeColour" : UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))])
        self.themeColour = self.defaults.colorForKey(key: "themeColour") ?? UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))
        self.defaults.synchronize()
        
        gameOverView.layoutSubviewsCompletion = {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
                self.gameOverView.alpha = 1
                self.gameOverView.backgroundColor = self.themeColour
            }, completion: nil)
            self.gameOverView.backgroundAnimation(currentLevel: self.currentLevel ?? 0)
            
            self.highscore = self.defaults.value(forKey: "highscore\(self.currentLevel ?? 0)\(self.currentDifficulty ?? 0)") as? Int ?? 0
            
            if (self.score ?? 0) > self.highscore {
                self.defaults.set(self.score, forKey: "highscore\(self.currentLevel ?? 0)\(self.currentDifficulty ?? 0)")
                self.gameOverView.beatHighScore()
            }
            
            self.highArray = self.defaults.array(forKey: "highscoreArray\(self.currentLevel ?? 0)\(self.currentDifficulty ?? 0)") as? [Double] ?? [0.0]
            //            print(self.highArray)
            if self.highArray.count == 0 {
                self.highArray.insert((Double(self.score ?? 0)), at: 0)
            } else  { // if self.highArray.count < 5
                self.highArray.append(Double(self.score ?? 0))
                //            } else {
                //                self.highArray[4] = Double(self.score ?? 0)
            }
            
            self.wrongArray = self.defaults.array(forKey: "wrongArray\(self.currentLevel ?? 0)\(self.currentDifficulty ?? 0)") as? [Double] ?? [0.0]
            if self.wrongArray.count == 0 {
                self.wrongArray.insert((Double(self.wrongAnswerCount ?? 0)), at: 0)
            } else  {
                self.wrongArray.append(Double(self.wrongAnswerCount ?? 0))
            }
            
            self.defaults.set(self.highArray, forKey: "highscoreArray\(self.currentLevel ?? 0)\(self.currentDifficulty ?? 0)")
            self.defaults.set(self.wrongArray, forKey: "wrongArray\(self.currentLevel ?? 0)\(self.currentDifficulty ?? 0)")
            self.defaults.synchronize()
            
            var location = 0
            switch (self.currentLevel, self.currentDifficulty) {
            case (1, 1): location = 0
            case (1, 2): location = 1
            case (1, 3): location = 2
            case (2, 1): location = 3
            case (2, 2): location = 4
            case (2, 3): location = 5
            case (3, 1): location = 6
            case (3, 2): location = 7
            case (3, 3): location = 8
            case (4, 1): location = 9
            case (4, 2): location = 10
            case (4, 3): location = 11
            default: print("Unknown location")
            }
            
            print((self.highArray.map { Int($0) }))
            self.firebaseDatabase.updateUser(allScoresCurrent: (self.highArray.map { Int($0) }), allWrongScoresCurrent: (self.wrongArray.map { Int($0) }), location: location) { isSuccess in
                if isSuccess {
                    print("success saved")
                } else {
                    print("failed to save")
                }
            }
            
            self.gameOverView.setupLineChart(highArray: self.highArray, wrongArray: self.wrongArray)
            
            self.gameOverView.setScore(score: self.score ?? 0, highscore: self.highscore, currentLevel: self.currentLevel ?? 0, currentDifficulty: self.currentDifficulty ?? 0, wrongAnswerCount: self.wrongAnswerCount ?? 0)
        }
        
        gameOverView.tryAgainButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        gameOverView.tryAgainButton.addTarget(self, action: #selector(tryAgainAction(_:)), for: .touchUpInside)
        gameOverView.tryAgainButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        gameOverView.returnToMenuButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        gameOverView.returnToMenuButton.addTarget(self, action: #selector(returnToMenuAction(_:)), for: .touchUpInside)
        gameOverView.returnToMenuButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
    }
    
    // restarts the same level
    @objc func tryAgainAction(_ sender: UIButton) {
        gameOverView.buttonExit(sender)
        
        let levelViewController = LevelViewController()
        levelViewController.currentLevel = currentLevel
        levelViewController.modalPresentationStyle = .overFullScreen
        present(levelViewController, animated: true)
    }
    
    // returns to menu
    @objc func returnToMenuAction(_ sender: UIButton) {
        gameOverView.buttonExit(sender)
        
        let menuViewController = MenuViewController()
        menuViewController.modalPresentationStyle = .overFullScreen
        present(menuViewController, animated: true)
    }
    
    // when completing a button press
    @objc func buttonUp(_ sender: UIButton) {
        gameOverView.buttonExit(sender)
    }
    
    // when canceling a button press
    @objc func buttonExit(_ sender: UIButton) {
        gameOverView.buttonExit(sender)
    }
    
    // when pressing a button
    @objc func buttonDown(_ sender: UIButton) {
        gameOverView.buttonDown(sender)
    }
    
    // restart the background animation when entering the app again
    @objc func didEnterForeground(_ notification: Notification) {
        gameOverView.backgroundAnimation(currentLevel: currentLevel ?? 0)
    }
    
    // sets the status bar colour
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}
