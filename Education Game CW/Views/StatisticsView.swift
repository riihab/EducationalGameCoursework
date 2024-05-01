//
//  StatisticsView.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 31/03/2024.
//

import Foundation
import UIKit
import DGCharts

class StatisticsView : UIView {
    
    var hasLayoutSubviewsBeenCalled = false
    var layoutSubviewsCompletion: (() -> Void)?
    
    let title = UILabel()
    
    let returnToMenuButton = UIButton()
    
    let scrollView = UIScrollView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 2
        addSubview(title)
        title.accessibilityLabel = "Statistics, scroll to view all stats"
        
        scrollView.showsVerticalScrollIndicator = true
        //        scrollView.backgroundColor = UIColor.blue
        addSubview(scrollView)
        scrollView.alpha = 1
        
        returnToMenuButton.backgroundColor = UIColor.white.withAlphaComponent(1)
        returnToMenuButton.tintColor = .white.withAlphaComponent(0.5)
        returnToMenuButton.isEnabled = true
        returnToMenuButton.isExclusiveTouch = true
        returnToMenuButton.adjustsImageWhenHighlighted = false
        returnToMenuButton.imageView?.contentMode = .scaleAspectFit
        returnToMenuButton.contentHorizontalAlignment = .center
        returnToMenuButton.titleLabel?.adjustsFontSizeToFitWidth = true
        returnToMenuButton.titleLabel?.numberOfLines = 1
        returnToMenuButton.layer.borderColor = UIColor.black.withAlphaComponent(1).cgColor
        returnToMenuButton.layer.borderWidth = 2
        returnToMenuButton.tag = 2
        addSubview(returnToMenuButton)
        returnToMenuButton.accessibilityLabel = "Return to menu"
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLayoutSubviewsBeenCalled {
            hasLayoutSubviewsBeenCalled = true
            
            let height = superview?.frame.height ?? 0
            let width = superview?.frame.width ?? 0
            
            scrollView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height*0.8)
            scrollView.center.x = self.bounds.width*0.5
            scrollView.center.y = self.bounds.height*0.6
            scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            //            scrollView.layer.borderColor = UIColor.black.cgColor
            //            scrollView.layer.borderWidth = 5
            //            scrollView.layer.cornerRadius = self.bounds.height*0.06875
            
            title.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.75, height: self.bounds.height*0.175)
            title.center.x = self.bounds.width*0.5
            title.center.y = self.bounds.height*0.125
            title.layer.cornerRadius = self.bounds.height*0.03125
            let attributeTitle = Attribute.outlineUnder(string: "Statistics", font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            let attributeTitle2 = Attribute.outline(string: "\nScroll to view all stats", font: FontKit.roundedFont(ofSize: self.bounds.height*0.025, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            attributeTitle.append(attributeTitle2)
            title.attributedText = attributeTitle
            
            returnToMenuButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            returnToMenuButton.center.x = width*0.5
            returnToMenuButton.center.y = height*0.85
            returnToMenuButton.layer.cornerRadius = height*0.0225
            let attributeSubButton = Attribute.outline(string: "Return to Menu", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            returnToMenuButton.setAttributedTitle(attributeSubButton, for: .normal)
            
            layoutSubviewsCompletion?()
        }
        
    }
    
    // creates the background animation
    @objc func backgroundAnimation() { // currentLevel: Int
        
        for view in self.subviews {
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
        
        let symbol = ["plus.circle.fill", "minus.circle.fill", "multiply.circle.fill", "divide.circle.fill"]
        //        switch currentLevel {
        //        case 1: symbol = ["plus.circle.fill", "flag.checkered.2.crossed"]
        //        case 2: symbol = ["minus.circle.fill", "flag.checkered.2.crossed"]
        //        case 3: symbol = ["multiply.circle.fill", "flag.checkered.2.crossed"]
        //        case 4: symbol = ["divide.circle.fill", "flag.checkered.2.crossed"]
        //        default: print("Unknown Level")
        //        }
        
        //        let symbol = ["flag.checkered.2.crossed"] // "plus.circle.fill", "minus.circle.fill", "multiply.circle.fill", "divide.circle.fill"]
        for i in -1...25 {
            for j in -1...10 {
                let backgroundButton = UIButton()
                backgroundButton.frame = CGRect(x: self.bounds.width*0.15*CGFloat(j) - self.bounds.width*0.2, y: self.bounds.width*0.15*CGFloat(i) - self.bounds.width*0.2, width: self.bounds.width*0.2, height: self.bounds.width*0.2)
                let configuration = UIImage.SymbolConfiguration(pointSize: CGFloat(self.bounds.width*0.05), weight: .black, scale: .large)
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
                
                UIView.animate(withDuration: TimeInterval(Double.random(in: 2.0...2.0)), delay: TimeInterval(Double(i+2)/10), usingSpringWithDamping: 100, initialSpringVelocity: 0, options: [.allowAnimatedContent, .autoreverse, .transitionFlipFromRight, .repeat], animations: {
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
