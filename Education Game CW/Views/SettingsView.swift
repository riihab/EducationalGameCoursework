//
//  SettingsView.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 04/02/2024.
//

import Foundation
import UIKit

class SettingsView : UIView {
    
    var hasLayoutSubviewsBeenCalled = false
    var layoutSubviewsCompletion: (() -> Void)?
    
    let title = UILabel()
    
    let colourButton = UIButton()
    let logOutButton = UIButton()
    
    let backButton = UIButton()
    
    let settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dragInteractionEnabled = false
        tableView.alwaysBounceVertical = false;
        //        tableView.isUserInteractionEnabled = false
        //        tableView.rowHeight = 125
        return tableView
    }()
    
    let settingsData = [("Speech Recognition", "Say 'Left' or 'Right' to choose an answer"), ("Head Movement", "Change the direction of your head to the left or right to choose an answer"), ("Device Motion", "Tilt the device left or right to choose an answer"),  ("", ""), ("Haptics", "Recieve appropriate vibrations when answering questions - disabling speech recognition allows haptics to function"), ("Coins", "Get coins for each correct answer, which can move when you tilt your deivce")]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        //        title.layer.backgroundColor = UIColor.white.withAlphaComponent(0.9).cgColor
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 1
        //        title.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        //        title.layer.borderWidth = 5
        addSubview(title)
        title.accessibilityLabel = "Settings"
        
        addSubview(settingsTableView)
        
        colourButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        colourButton.tintColor = .white.withAlphaComponent(0.5)
        colourButton.isEnabled = true
        colourButton.isExclusiveTouch = true
        colourButton.adjustsImageWhenHighlighted = false
        colourButton.imageView?.contentMode = .scaleAspectFit
        colourButton.contentHorizontalAlignment = .center
        colourButton.titleLabel?.adjustsFontSizeToFitWidth = true
        colourButton.titleLabel?.numberOfLines = 1
        colourButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        colourButton.layer.borderWidth = 5
        addSubview(colourButton)
        colourButton.accessibilityLabel = "Change theme"
        
        logOutButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.9)
        logOutButton.tintColor = .white.withAlphaComponent(0.5)
        logOutButton.isEnabled = true
        logOutButton.isExclusiveTouch = true
        logOutButton.adjustsImageWhenHighlighted = false
        logOutButton.imageView?.contentMode = .scaleAspectFit
        logOutButton.contentHorizontalAlignment = .center
        logOutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        logOutButton.titleLabel?.numberOfLines = 1
        logOutButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        logOutButton.layer.borderWidth = 5
        addSubview(logOutButton)
        logOutButton.accessibilityLabel = "Log out"
        
        backButton.backgroundColor = UIColor.clear
        backButton.tintColor = .black.withAlphaComponent(1.0)
        backButton.isEnabled = true
        backButton.isExclusiveTouch = true
        backButton.adjustsImageWhenHighlighted = false
        backButton.imageView?.contentMode = .scaleAspectFit
        addSubview(backButton)
        backButton.accessibilityLabel = "Return"
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLayoutSubviewsBeenCalled {
            hasLayoutSubviewsBeenCalled = true
            
            let height = superview?.frame.height ?? 0
            let width = superview?.frame.width ?? 0
            
            title.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.125)
            title.center.x = self.bounds.width*0.5
            title.center.y = self.bounds.height*0.15
            title.layer.cornerRadius = self.bounds.height*0.03125
            let attributeTitle = Attribute.outline(string: "Settings", font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .heavy), outlineSize: 0, textColor: .black, outlineColor: .black)
            title.attributedText = attributeTitle
            
            colourButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            colourButton.center.x = width*0.5
            colourButton.center.y = height*0.8
            colourButton.layer.cornerRadius = height*0.0225
            let attributeAddButton = Attribute.outline(string: "Change Theme", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            colourButton.setAttributedTitle(attributeAddButton, for: .normal)
            
            logOutButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            logOutButton.center.x = width*0.5
            logOutButton.center.y = height*0.9
            logOutButton.layer.cornerRadius = height*0.0225
            let attributeAddButton2 = Attribute.outline(string: "Log Out", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            logOutButton.setAttributedTitle(attributeAddButton2, for: .normal)
            
            backButton.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.2, height: self.bounds.width*0.2)
            backButton.center.x = width*0.15
            backButton.center.y = self.bounds.height*0.15
            let addImageConfig = UIImage.SymbolConfiguration(pointSize: (width*0.2), weight: .heavy, scale: .large)
            let addImage = UIImage(systemName: "arrow.backward.square.fill", withConfiguration: addImageConfig)
            backButton.setImage(addImage, for: .normal)
            
            settingsTableView.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.7)
            settingsTableView.center.x = self.bounds.width*0.5
            settingsTableView.center.y = self.bounds.height*0.525
            //            settingsTableView.layer.cornerRadius = self.bounds.height*0.03125
            
            layoutSubviewsCompletion?()
        }
        
    }
    
    // creates the background animation
    @objc func backgroundAnimation() {
        
        for view in self.subviews {
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
        
        let symbol = ["gearshape", "gearshape.fill"] // ["plus.circle.fill", "minus.circle.fill", "multiply.circle.fill", "divide.circle.fill"]
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
                    backgroundButton.alpha = 0.15
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
