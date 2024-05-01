//
//  LoginViewController.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 23/03/2024.
//

import Foundation
import UIKit
import CoreMotion
import Speech
import UserNotifications
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    var loginView = LoginView()
    var isFromLaunch: Bool?
    
    var defaults = UserDefaults.standard
    var appOpenCount = 0
    
    var themeColour = UIColor.white
    
    var isSigningUp = false
    var shouldEnterMenu = false
    
    let firebaseDatabase = FirebaseDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        firebaseDatabase.configureDatabase()
        
        self.appOpenCount = self.defaults.value(forKey: "appOpenCount") as? Int ?? 0
        
        view.backgroundColor = UIColor.white
        
        //        self.defaults.register(defaults: ["themeColour" : UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))])
        //        self.themeColour = self.defaults.colorForKey(key: "themeColour") ?? UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))
        //        self.defaults.synchronize()
        
        loginView = LoginView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        loginView.center.x = view.bounds.width*0.5
        loginView.center.y = view.bounds.height*0.5
        loginView.alpha = 0
        view.addSubview(loginView)
        
        loginView.layoutSubviewsCompletion = {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
                self.loginView.alpha = 1
                //                self.loginView.backgroundColor = self.themeColour
            }, completion: nil)
            
            self.loginView.backgroundAnimation()
            
            if self.isFromLaunch ?? false {
            }
            
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        //        tap.cancelsTouchesInView = false
        loginView.addGestureRecognizer(tap)
        
        loginView.loginButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        loginView.loginButton.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
        loginView.loginButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        loginView.signUpButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        loginView.signUpButton.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        loginView.backButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        loginView.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        loginView.backButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        loginView.usernameView.delegate = self
        loginView.passwordView.delegate = self
        
    }
    
    @objc func loginAction(_ sender: UIButton) {
        loginView.buttonExit(sender)
        
        if shouldEnterMenu == false {
            if sender.tag == 1 { // log in
                isSigningUp = false
            } else if sender.tag == 2 { // sign up
                isSigningUp = true
            }
            
            loginView.loginAction(isSigningUp: isSigningUp)
            shouldEnterMenu = true
        } else {
            
            if sender.tag == 1 { // log in
                firebaseDatabase.loginUser(withUsername: loginView.usernameView.text ?? "", andPassword: loginView.passwordView.text ?? "") { isSuccess in
                    if isSuccess {
                        print("User successfully logged in.")
                        // Proceed with successful login actions here
                        self.startGame()
                    } else {
                        print("Login failed.")
                        // Handle login failure here
                        self.loginFailed()
                    }
                }
            } else if sender.tag == 2 { // sign up
                if loginView.usernameView.text != "" && loginView.passwordView.text != "" {
                    firebaseDatabase.checkAndCreateUser(username: loginView.usernameView.text ?? "", password: loginView.passwordView.text ?? "", theme: "", settings: [false,true,true,true,true], allScores: [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]], allWrongScores: [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]], askedQuestions: [[], [], [], []]) { isSuccess in
                        if isSuccess {
                            print("User created successfully.")
                            // Handle successful user creation here
                            self.startGame()
                        } else {
                            print("Failed to create user.")
                            // Handle failure to create a user here
                            self.signUpFailed()
                        }
                    }
                }
            }
        }
    }
    
    @objc func startGame() {
        let menuViewController = MenuViewController()
        menuViewController.isFromLaunch = true
        menuViewController.modalPresentationStyle = .fullScreen
        present(menuViewController, animated: false)
    }
    
    @objc func loginFailed() {
        let title = "Login Failed"
        let description = "Username or password is incorrect"
        let alert = UIAlertController(title: "\(title)", message: "\(description)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
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
    
    @objc func signUpFailed() {
        let title = "Sign Up Failed"
        let description = "Failed to create account"
        let alert = UIAlertController(title: "\(title)", message: "\(description)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
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
    
    @objc func backAction(_ sender: UIButton) {
        loginView.buttonExit(sender)
        shouldEnterMenu = false
        loginView.endEditing(true)
        loginView.backAction()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Text field did begin editing")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Text field did end editing")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        loginView.endEditing(true)
        //        loginView.usernameView.resignFirstResponder()
        //        loginView.passwordView.resignFirstResponder()
    }
    
    // when completing a button press
    @objc func buttonUp(_ sender: UIButton) {
        loginView.buttonExit(sender)
    }
    
    // when canceling a button press
    @objc func buttonExit(_ sender: UIButton) {
        loginView.buttonExit(sender)
    }
    
    // when pressing a button
    @objc func buttonDown(_ sender: UIButton) {
        loginView.buttonDown(sender)
    }
    
    // restart the background animation when entering the app again
    @objc func didEnterForeground(_ notification: Notification) {
        loginView.backgroundAnimation()
    }
    
    // sets the status bar colour
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}

extension UIViewController {
}
