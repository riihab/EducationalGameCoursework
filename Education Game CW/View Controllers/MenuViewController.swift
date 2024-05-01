//
//  MenuViewController.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 11/12/2023.
//

import Foundation
import UIKit
import CoreMotion
import Speech
import UserNotifications

class MenuViewController: UIViewController  {
    
    var menuView = MenuView()
    var isFromLaunch: Bool?
    
    var defaults = UserDefaults.standard
    var appOpenCount = 0
    
    var themeColour = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.appOpenCount = self.defaults.value(forKey: "appOpenCount") as? Int ?? 0
        
        view.backgroundColor = UIColor.white
        
        //        self.defaults.register(defaults: ["themeColour" : UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))])
        self.themeColour = self.defaults.colorForKey(key: "themeColour") ?? UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))
        self.defaults.synchronize()
        
        menuView = MenuView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        menuView.center.x = view.bounds.width*0.5
        menuView.center.y = view.bounds.height*0.5
        menuView.alpha = 0
        view.addSubview(menuView)
        
        menuView.layoutSubviewsCompletion = {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
                self.menuView.alpha = 1
                self.menuView.backgroundColor = self.themeColour
            }, completion: nil)
            
            self.menuView.backgroundAnimation()
            
            if self.isFromLaunch ?? false {
            }
            
            self.requestTranscribePermissions()
            self.scheduleReminder()
        }
        
        menuView.additionButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        menuView.additionButton.addTarget(self, action: #selector(levelAction(_:)), for: .touchUpInside)
        menuView.additionButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        menuView.subtractionButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        menuView.subtractionButton.addTarget(self, action: #selector(levelAction(_:)), for: .touchUpInside)
        menuView.subtractionButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        menuView.divisionButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        menuView.divisionButton.addTarget(self, action: #selector(levelAction(_:)), for: .touchUpInside)
        menuView.divisionButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        menuView.multiplicationButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        menuView.multiplicationButton.addTarget(self, action: #selector(levelAction(_:)), for: .touchUpInside)
        menuView.multiplicationButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        menuView.statisticsButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        menuView.statisticsButton.addTarget(self, action: #selector(statisticsAction(_:)), for: .touchUpInside)
        menuView.statisticsButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        menuView.settingsButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        menuView.settingsButton.addTarget(self, action: #selector(settingsAction(_:)), for: .touchUpInside)
        menuView.settingsButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        menuView.informationButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        menuView.informationButton.addTarget(self, action: #selector(informationAction(_:)), for: .touchUpInside)
        menuView.informationButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
    }
    
    // Schedule spaced repetition reminders
    func scheduleReminder() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted && self.appOpenCount == 0 {
                // Initial time interval
                var timeInterval: TimeInterval = 60
                
                // Loop to schedule reminders
                for i in 1...25 {
                    // Create content for the notification
                    let content = UNMutableNotificationContent()
                    content.title = "Spaced Repetition!"
                    content.body = "It's time for another round!"
                    
                    // Create a trigger to display the notification after the calculated time interval
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                    
                    // Create a request for the notification
                    let request = UNNotificationRequest(identifier: "reminderNotification_\(i)", content: content, trigger: trigger)
                    
                    // Add the request to the notification center
                    UNUserNotificationCenter.current().add(request) { (error) in
                        if let error = error {
                            print("Error scheduling notification: \(error.localizedDescription)")
                        } else {
                            //                            print("Reminder \(i) notification scheduled successfully.")
                        }
                    }
                    
                    // Double the time interval for the next reminder
                    timeInterval *= 2
                }
            } else if granted == false {
                print("Notification authorization denied: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    // request to allow speech recognition
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                // User authorized speech recognition, you can start recognition
            } else {
                // Handle the case where the user denied authorization or restricted access
            }
        }
    }
    
    // when tapping on statistics
    @objc func statisticsAction(_ sender: UIButton) {
        menuView.buttonExit(sender)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.modalPresentationStyle = .overFullScreen
        present(statisticsViewController, animated: true)
    }
    
    // when tapping on settings
    @objc func settingsAction(_ sender: UIButton) {
        menuView.buttonExit(sender)
        
        let settingsViewController = SettingsViewController()
        settingsViewController.modalPresentationStyle = .overFullScreen
        present(settingsViewController, animated: true)
    }
    
    // when tapping on information
    @objc func informationAction(_ sender: UIButton) {
        menuView.buttonExit(sender)
        howToInfo()
    }
    
    // called first time entering level, to get user to understand how to play
    @objc func howToInfo() {
        let title = "How To Play"
        let description = "Tap the correct answer to increase your score - for every point a new coin will appear - which you can play with by moving the device!\n\nUse a variety of input methods to choose an answer along with tapping including: speech recognition; head movement and device motion! (check out settings to better understand the input methods)\n\nOnce the timer is up, the level is completed - good luck!"
        let alert = UIAlertController(title: "\(title)", message: "\(description)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: { action in
            switch action.style {
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            default:
                print("default")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // when tapping on a level
    @objc func levelAction(_ sender: UIButton) {
        menuView.buttonExit(sender)
        
        let levelViewController = LevelViewController()
        levelViewController.currentLevel = sender.tag
        levelViewController.modalPresentationStyle = .overFullScreen
        present(levelViewController, animated: true)
    }
    
    // when completing a button press
    @objc func buttonUp(_ sender: UIButton) {
        menuView.buttonExit(sender)
    }
    
    // when canceling a button press
    @objc func buttonExit(_ sender: UIButton) {
        menuView.buttonExit(sender)
    }
    
    // when pressing a button
    @objc func buttonDown(_ sender: UIButton) {
        menuView.buttonDown(sender)
    }
    
    // restart the background animation when entering the app again
    @objc func didEnterForeground(_ notification: Notification) {
        menuView.backgroundAnimation()
    }
    
    // sets the status bar colour
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}
