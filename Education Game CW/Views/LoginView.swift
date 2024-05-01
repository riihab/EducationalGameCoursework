//
//  LoginView.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 23/03/2024.
//

import Foundation
import UIKit

class LoginView : UIView {
    
    var hasLayoutSubviewsBeenCalled = false
    var layoutSubviewsCompletion: (() -> Void)?
    
    let title = UILabel()
    let subtitle = UILabel()
    
    let loginButton = UIButton()
    let signUpButton = UIButton()
    
    let usernameView = UITextField()
    let passwordView = UITextField()
    
    let backButton = UIButton()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))
        
        //        title.layer.backgroundColor = UIColor.white.withAlphaComponent(0.9).cgColor
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 1
        //        title.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        //        title.layer.borderWidth = 5
        addSubview(title)
        title.accessibilityLabel = "Mathy"
        
        //        subtitle.layer.backgroundColor = UIColor.white.withAlphaComponent(0.9).cgColor
        subtitle.textAlignment = .center
        subtitle.adjustsFontSizeToFitWidth = true
        subtitle.numberOfLines = 2
        //        subtitle.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        //        subtitle.layer.borderWidth = 5
        addSubview(subtitle)
        subtitle.accessibilityLabel = "Log in with an existing account or sign up to create a new account"
        
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        loginButton.tintColor = .white.withAlphaComponent(0.5)
        loginButton.isEnabled = true
        loginButton.isExclusiveTouch = true
        loginButton.adjustsImageWhenHighlighted = false
        loginButton.imageView?.contentMode = .scaleAspectFit
        loginButton.contentHorizontalAlignment = .center
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        loginButton.titleLabel?.numberOfLines = 1
        loginButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        loginButton.layer.borderWidth = 5
        loginButton.tag = 1
        addSubview(loginButton)
        loginButton.accessibilityLabel = "Log In"
        
        signUpButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        signUpButton.tintColor = .white.withAlphaComponent(0.5)
        signUpButton.isEnabled = true
        signUpButton.isExclusiveTouch = true
        signUpButton.adjustsImageWhenHighlighted = false
        signUpButton.imageView?.contentMode = .scaleAspectFit
        signUpButton.contentHorizontalAlignment = .center
        signUpButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signUpButton.titleLabel?.numberOfLines = 1
        signUpButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        signUpButton.layer.borderWidth = 5
        signUpButton.tag = 2
        addSubview(signUpButton)
        signUpButton.accessibilityLabel = "Sign Up"
        
        usernameView.layer.backgroundColor = UIColor.white.withAlphaComponent(0.9).cgColor
        usernameView.textAlignment = .left
        usernameView.adjustsFontSizeToFitWidth = true
        //        usernameView.numberOfLines = 1
        usernameView.layer.borderColor = UIColor.black.withAlphaComponent(0.9).cgColor
        usernameView.layer.borderWidth = 2
        addSubview(usernameView)
        usernameView.accessibilityLabel = "Username"
        usernameView.alpha = 0
        //        usernameView.borderStyle = .roundedRect
        usernameView.textColor = UIColor.black
        usernameView.font = FontKit.roundedFont(ofSize: self.bounds.height*0.025, weight: .bold)
        usernameView.tintColor = UIColor.black
        usernameView.placeholder = "Username"
        usernameView.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.65)]
        )
        
        passwordView.layer.backgroundColor = UIColor.white.withAlphaComponent(0.9).cgColor
        passwordView.textAlignment = .left
        passwordView.adjustsFontSizeToFitWidth = true
        //        passwordView.numberOfLines = 1
        passwordView.layer.borderColor = UIColor.black.withAlphaComponent(0.9).cgColor
        passwordView.layer.borderWidth = 2
        addSubview(passwordView)
        passwordView.accessibilityLabel = "Pasword"
        passwordView.alpha = 0
        //        passwordView.borderStyle = .roundedRect
        passwordView.textColor = UIColor.black
        passwordView.font = FontKit.roundedFont(ofSize: self.bounds.height*0.025, weight: .bold)
        passwordView.tintColor = UIColor.black
        passwordView.placeholder = "Password"
        passwordView.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.65)]
        )
        
        backButton.backgroundColor = UIColor.clear
        backButton.tintColor = .black.withAlphaComponent(1)
        backButton.isEnabled = true
        backButton.isExclusiveTouch = true
        backButton.adjustsImageWhenHighlighted = false
        backButton.imageView?.contentMode = .scaleAspectFit
        addSubview(backButton)
        backButton.accessibilityLabel = "Back"
        backButton.alpha = 0
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLayoutSubviewsBeenCalled {
            hasLayoutSubviewsBeenCalled = true
            
            let height = superview?.frame.height ?? 0
            let width = superview?.frame.width ?? 0
            
            title.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.15)
            title.center.x = self.bounds.width*0.5
            title.center.y = self.bounds.height*0.3
            title.layer.cornerRadius = self.bounds.height*0.03125
            let attributeTitle = Attribute.outlineUnder(string: "Mathy", font: FontKit.roundedFont(ofSize: self.bounds.height*0.075, weight: .heavy), outlineSize: 0, textColor: .black, outlineColor: .black)
            title.attributedText = attributeTitle
            
            subtitle.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.15)
            subtitle.center.x = self.bounds.width*0.5
            subtitle.center.y = self.bounds.height*0.55
            subtitle.layer.cornerRadius = self.bounds.height*0.03125
            let attributeTitle2 = Attribute.outline(string: "Log in with an existing account\n or sign up to create a new account", font: FontKit.roundedFont(ofSize: self.bounds.height*0.025, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            subtitle.attributedText = attributeTitle2
            
            loginButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            loginButton.center.x = width*0.5
            loginButton.center.y = height*0.65
            loginButton.layer.cornerRadius = height*0.0225
            let attributeAddButton = Attribute.outline(string: "Log In", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            loginButton.setAttributedTitle(attributeAddButton, for: .normal)
            
            signUpButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            signUpButton.center.x = width*0.5
            signUpButton.center.y = height*0.75
            signUpButton.layer.cornerRadius = height*0.0225
            let attributeSubButton = Attribute.outline(string: "Sign Up", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            signUpButton.setAttributedTitle(attributeSubButton, for: .normal)
            
            usernameView.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.075)
            usernameView.center.x = self.bounds.width*0.5
            usernameView.center.y = self.bounds.height*0.45
            usernameView.layer.cornerRadius = self.bounds.height*0.015625
            //            let attributeTitle3 = Attribute.outline(string: "Username...", font: FontKit.roundedFont(ofSize: self.bounds.height*0.025, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            //            usernameView.attributedText = attributeTitle3
            usernameView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: usernameView.frame.height))
            usernameView.leftViewMode = .always
            
            passwordView.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.075)
            passwordView.center.x = self.bounds.width*0.5
            passwordView.center.y = self.bounds.height*0.55
            passwordView.layer.cornerRadius = self.bounds.height*0.015625
            //            let attributeTitle3 = Attribute.outline(string: "Username...", font: FontKit.roundedFont(ofSize: self.bounds.height*0.025, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            //            usernameView.attributedText = attributeTitle3
            passwordView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: passwordView.frame.height))
            passwordView.leftViewMode = .always
            
            backButton.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.2, height: self.bounds.width*0.2)
            backButton.center.x = width*0.15
            backButton.center.y = self.bounds.height*0.15
            let addImageConfig2 = UIImage.SymbolConfiguration(pointSize: (width*0.2), weight: .heavy, scale: .large)
            let addImage2 = UIImage(systemName: "arrow.backward.square.fill", withConfiguration: addImageConfig2)
            backButton.setImage(addImage2, for: .normal)
            
            layoutSubviewsCompletion?()
        }
        
    }
    
    @objc func loginAction(isSigningUp: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
            
            if isSigningUp == true {
                self.loginButton.alpha = 0
                self.signUpButton.center.y = self.bounds.height*0.85
            } else {
                self.signUpButton.alpha = 0
                self.loginButton.center.y = self.bounds.height*0.85
            }
            
            self.usernameView.alpha = 1
            self.passwordView.alpha = 1
            
            self.subtitle.alpha = 0
            self.backButton.alpha = 1
        }, completion: nil)
    }
    
    @objc func backAction() {
        usernameView.text = ""
        passwordView.text = ""
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
            
            self.loginButton.alpha = 1
            self.loginButton.center.y = self.bounds.height*0.65
            
            self.signUpButton.alpha = 1
            self.signUpButton.center.y = self.bounds.height*0.75
            
            self.usernameView.alpha = 0
            self.passwordView.alpha = 0
            
            self.subtitle.alpha = 1
            self.backButton.alpha = 0
        }, completion: nil)
    }
    
    // creates the background animation
    @objc func backgroundAnimation() {
        
        for view in self.subviews {
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
        
        let symbol = ["plus.circle.fill", "minus.circle.fill", "multiply.circle.fill", "divide.circle.fill"]
        for i in -1...25 {
            for j in -1...10 {
                let backgroundButton = UIButton()
                backgroundButton.frame = CGRect(x: self.bounds.width*0.15*CGFloat(j) - self.bounds.width*0.2, y: self.bounds.width*0.15*CGFloat(i) - self.bounds.width*0.2, width: self.bounds.width*0.2, height: self.bounds.width*0.2)
                let configuration = UIImage.SymbolConfiguration(pointSize: CGFloat(self.bounds.width*0.1), weight: .black, scale: .large)
                let image = UIImage(systemName: "\(symbol.randomElement() ?? "")", withConfiguration: configuration)?.withTintColor(UIColor(hue: CGFloat(Double.random(in: 0.0...0.0)), saturation: CGFloat(Double.random(in: 0...0)), brightness: CGFloat(Double.random(in: 1...1)), alpha: 1).withAlphaComponent(1), renderingMode: .alwaysOriginal)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = image
                let imageString = NSAttributedString(attachment: imageAttachment)
                backgroundButton.setAttributedTitle(imageString, for: .normal)
                addSubview(backgroundButton)
                backgroundButton.tag = 999
                backgroundButton.alpha = 0.0
                sendSubviewToBack(backgroundButton)
                backgroundButton.accessibilityElementsHidden = true
                
                UIView.animate(withDuration: TimeInterval(Double.random(in: 1.0...1.0)), delay: TimeInterval(Double(i+2)/10), usingSpringWithDamping: 100, initialSpringVelocity: 0, options: [.allowAnimatedContent, .autoreverse, .transitionFlipFromRight, .repeat], animations: {
                    backgroundButton.alpha = 0.5
                    //                    backgroundButton.center.y += CGFloat.random(in: -self.bounds.height*0.15...self.bounds.height*0.15)
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
        
        switch sender {
        default:
            let impact = UISelectionFeedbackGenerator()
            impact.selectionChanged()
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
        }, completion: nil)
    }
    
}
