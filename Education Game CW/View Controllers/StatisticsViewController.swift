//
//  StatisticsViewController.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 31/03/2024.
//

import Foundation
import UIKit

class StatisticsViewController: UIViewController  {
    
    var statisticsView = StatisticsView()
    var smallStatisticsViews = [SmallStatisticsView]()
    
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
        
        view.backgroundColor = UIColor.white
        
        statisticsView = StatisticsView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        statisticsView.center.x = view.bounds.width*0.5
        statisticsView.center.y = view.bounds.height*0.5
        statisticsView.alpha = 0
        view.addSubview(statisticsView)
        
        //        print((self.highArray.map { Int($0) }))
        
        let totalSmallViewsHeight = CGFloat(11) * (view.bounds.height*0.27)
        let finalHeight = totalSmallViewsHeight + self.view.bounds.height*0.5
        statisticsView.scrollView.contentSize = CGSize(width: view.bounds.width, height: finalHeight)
        var addedHeight = view.bounds.height*0.3
        if finalHeight > view.bounds.height {
            addedHeight = view.bounds.height*0.125
        }
        
        for i in 0..<12 {
            
            switch (i+1) {
            case (1): self.currentLevel = 1; self.currentDifficulty = 1
            case (2): self.currentLevel = 1; self.currentDifficulty = 2
            case (3): self.currentLevel = 1; self.currentDifficulty = 3
            case (4): self.currentLevel = 2; self.currentDifficulty = 1
            case (5): self.currentLevel = 2; self.currentDifficulty = 2
            case (6): self.currentLevel = 2; self.currentDifficulty = 3
            case (7): self.currentLevel = 3; self.currentDifficulty = 1
            case (8): self.currentLevel = 3; self.currentDifficulty = 2
            case (9): self.currentLevel = 3; self.currentDifficulty = 3
            case (10):self.currentLevel = 4; self.currentDifficulty = 1
            case (11):self.currentLevel = 4; self.currentDifficulty = 2
            case (12):self.currentLevel = 4; self.currentDifficulty = 3
            default: print("Unknown i")
            }
            
            self.highscore = self.defaults.value(forKey: "highscore\(self.currentLevel ?? 0)\(self.currentDifficulty ?? 0)") as? Int ?? 0
            
            self.highArray = self.defaults.array(forKey: "highscoreArray\(self.currentLevel ?? 0)\(self.currentDifficulty ?? 0)") as? [Double] ?? [0.0]
            //        if self.highArray.count == 0 {
            //            self.highArray.insert((Double(self.score ?? 0)), at: 0)
            //        } else  {
            //            self.highArray.append(Double(self.score ?? 0))
            //        }
            
            self.wrongArray = self.defaults.array(forKey: "wrongArray\(self.currentLevel ?? 0)\(self.currentDifficulty ?? 0)") as? [Double] ?? [0.0]
            //        if self.wrongArray.count == 0 {
            //            self.wrongArray.insert((Double(self.wrongAnswerCount ?? 0)), at: 0)
            //        } else  {
            //            self.wrongArray.append(Double(self.wrongAnswerCount ?? 0))
            //        }
            
            let smallView = SmallStatisticsView(frame: CGRect(x: 0, y: 0, width: view.bounds.width*0.9, height: view.bounds.height*0.25))
            smallView.center.x = view.bounds.width*0.5
            smallView.center.y = (view.bounds.height*0.27*CGFloat(i)) + addedHeight
            smallView.translatesAutoresizingMaskIntoConstraints = false
            statisticsView.scrollView.addSubview(smallView)
            
            smallView.tag = i
            
            //            smallView.layoutSubviewsCompletion = {
            smallView.setScore(highscore: self.highscore, currentLevel: self.currentLevel ?? 1, currentDifficulty: self.currentDifficulty ?? 1)
            smallView.setupLineChart(highArray: self.highArray, wrongArray: self.wrongArray)
            //            }
            
            smallStatisticsViews.append(smallView)
        }
        
        //        self.defaults.register(defaults: ["themeColour" : UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))])
        self.themeColour = self.defaults.colorForKey(key: "themeColour") ?? UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))
        self.defaults.synchronize()
        
        statisticsView.layoutSubviewsCompletion = {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
                self.statisticsView.alpha = 1
                self.statisticsView.backgroundColor = self.themeColour
            }, completion: nil)
            self.statisticsView.backgroundAnimation()
        }
        
        statisticsView.returnToMenuButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        statisticsView.returnToMenuButton.addTarget(self, action: #selector(returnToMenuAction(_:)), for: .touchUpInside)
        statisticsView.returnToMenuButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
    }
    
    // returns to menu
    @objc func returnToMenuAction(_ sender: UIButton) {
        statisticsView.buttonExit(sender)
        
        let menuViewController = MenuViewController()
        menuViewController.modalPresentationStyle = .overFullScreen
        present(menuViewController, animated: true)
    }
    
    // when completing a button press
    @objc func buttonUp(_ sender: UIButton) {
        statisticsView.buttonExit(sender)
    }
    
    // when canceling a button press
    @objc func buttonExit(_ sender: UIButton) {
        statisticsView.buttonExit(sender)
    }
    
    // when pressing a button
    @objc func buttonDown(_ sender: UIButton) {
        statisticsView.buttonDown(sender)
    }
    
    // restart the background animation when entering the app again
    @objc func didEnterForeground(_ notification: Notification) {
        statisticsView.backgroundAnimation()
    }
    
    // sets the status bar colour
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}
