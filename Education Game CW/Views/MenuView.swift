//
//  MenuView.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 11/12/2023.
//

import Foundation
import UIKit

class MenuView : UIView {
    
    var hasLayoutSubviewsBeenCalled = false
    var layoutSubviewsCompletion: (() -> Void)?
    
    let title = UILabel()
    
    let additionButton = UIButton()
    let subtractionButton = UIButton()
    let multiplicationButton = UIButton()
    let divisionButton = UIButton()
    
    let statisticsButton = UIButton()
    
    let settingsButton = UIButton()
    let informationButton = UIButton()
    
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
        title.accessibilityLabel = "Mathy"
        
        additionButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        additionButton.tintColor = .white.withAlphaComponent(0.5)
        additionButton.isEnabled = true
        additionButton.isExclusiveTouch = true
        additionButton.adjustsImageWhenHighlighted = false
        additionButton.imageView?.contentMode = .scaleAspectFit
        additionButton.contentHorizontalAlignment = .center
        additionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        additionButton.titleLabel?.numberOfLines = 1
        additionButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        additionButton.layer.borderWidth = 5
        additionButton.tag = 1
        addSubview(additionButton)
        additionButton.accessibilityLabel = "Addition"
        
        subtractionButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        subtractionButton.tintColor = .white.withAlphaComponent(0.5)
        subtractionButton.isEnabled = true
        subtractionButton.isExclusiveTouch = true
        subtractionButton.adjustsImageWhenHighlighted = false
        subtractionButton.imageView?.contentMode = .scaleAspectFit
        subtractionButton.contentHorizontalAlignment = .center
        subtractionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        subtractionButton.titleLabel?.numberOfLines = 1
        subtractionButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        subtractionButton.layer.borderWidth = 5
        subtractionButton.tag = 2
        addSubview(subtractionButton)
        subtractionButton.accessibilityLabel = "Subtraction"
        
        multiplicationButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        multiplicationButton.tintColor = .white.withAlphaComponent(0.5)
        multiplicationButton.isEnabled = true
        multiplicationButton.isExclusiveTouch = true
        multiplicationButton.adjustsImageWhenHighlighted = false
        multiplicationButton.imageView?.contentMode = .scaleAspectFit
        multiplicationButton.contentHorizontalAlignment = .center
        multiplicationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        multiplicationButton.titleLabel?.numberOfLines = 1
        multiplicationButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        multiplicationButton.layer.borderWidth = 5
        multiplicationButton.tag = 3
        addSubview(multiplicationButton)
        multiplicationButton.accessibilityLabel = "Multiplication"
        
        divisionButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        divisionButton.tintColor = .white.withAlphaComponent(0.5)
        divisionButton.isEnabled = true
        divisionButton.isExclusiveTouch = true
        divisionButton.adjustsImageWhenHighlighted = false
        divisionButton.imageView?.contentMode = .scaleAspectFit
        divisionButton.contentHorizontalAlignment = .center
        divisionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        divisionButton.titleLabel?.numberOfLines = 1
        divisionButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        divisionButton.layer.borderWidth = 5
        divisionButton.tag = 4
        addSubview(divisionButton)
        divisionButton.accessibilityLabel = "Division"
        
        statisticsButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        statisticsButton.tintColor = .white.withAlphaComponent(0.5)
        statisticsButton.isEnabled = true
        statisticsButton.isExclusiveTouch = true
        statisticsButton.adjustsImageWhenHighlighted = false
        statisticsButton.imageView?.contentMode = .scaleAspectFit
        statisticsButton.contentHorizontalAlignment = .center
        statisticsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        statisticsButton.titleLabel?.numberOfLines = 1
        statisticsButton.layer.borderColor = UIColor.black.withAlphaComponent(1).cgColor
        statisticsButton.layer.borderWidth = 2
        //        statisticsButton.tag = 4
        addSubview(statisticsButton)
        statisticsButton.accessibilityLabel = "Statistics"
        
        settingsButton.backgroundColor = UIColor.clear
        settingsButton.tintColor = .black.withAlphaComponent(1)
        settingsButton.isEnabled = true
        settingsButton.isExclusiveTouch = true
        settingsButton.adjustsImageWhenHighlighted = false
        settingsButton.imageView?.contentMode = .scaleAspectFit
        addSubview(settingsButton)
        settingsButton.accessibilityLabel = "Settings"
        
        informationButton.backgroundColor = UIColor.clear
        informationButton.tintColor = .black.withAlphaComponent(1)
        informationButton.isEnabled = true
        informationButton.isExclusiveTouch = true
        informationButton.adjustsImageWhenHighlighted = false
        informationButton.imageView?.contentMode = .scaleAspectFit
        addSubview(informationButton)
        informationButton.accessibilityLabel = "Information"
        
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
            
            additionButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            additionButton.center.x = width*0.5
            additionButton.center.y = height*0.45
            additionButton.layer.cornerRadius = height*0.0225
            let attributeAddButton = Attribute.outline(string: "Addition  +", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            additionButton.setAttributedTitle(attributeAddButton, for: .normal)
            
            subtractionButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            subtractionButton.center.x = width*0.5
            subtractionButton.center.y = height*0.55
            subtractionButton.layer.cornerRadius = height*0.0225
            let attributeSubButton = Attribute.outline(string: "Subtraction  -", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            subtractionButton.setAttributedTitle(attributeSubButton, for: .normal)
            
            multiplicationButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            multiplicationButton.center.x = width*0.5
            multiplicationButton.center.y = height*0.65
            multiplicationButton.layer.cornerRadius = height*0.0225
            let attributeMulButton = Attribute.outline(string: "Multiplication  ×", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            multiplicationButton.setAttributedTitle(attributeMulButton, for: .normal)
            
            divisionButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            divisionButton.center.x = width*0.5
            divisionButton.center.y = height*0.75
            divisionButton.layer.cornerRadius = height*0.0225
            let attributeDivButton = Attribute.outline(string: "Division  ÷", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            divisionButton.setAttributedTitle(attributeDivButton, for: .normal)
            
            statisticsButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            statisticsButton.center.x = width*0.5
            statisticsButton.center.y = height*0.85
            statisticsButton.layer.cornerRadius = height*0.0225
            let attributeStaButton = Attribute.outlineUnder(string: "Statistics", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            statisticsButton.setAttributedTitle(attributeStaButton, for: .normal)
            
            settingsButton.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.2, height: self.bounds.width*0.2)
            settingsButton.center.x = width*0.85
            settingsButton.center.y = self.bounds.height*0.15
            let addImageConfig = UIImage.SymbolConfiguration(pointSize: (width*0.2), weight: .heavy, scale: .large)
            let addImage = UIImage(systemName: "gear", withConfiguration: addImageConfig)
            settingsButton.setImage(addImage, for: .normal)
            
            informationButton.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.2, height: self.bounds.width*0.2)
            informationButton.center.x = width*0.15
            informationButton.center.y = self.bounds.height*0.15
            let addImageConfig2 = UIImage.SymbolConfiguration(pointSize: (width*0.2), weight: .heavy, scale: .large)
            let addImage2 = UIImage(systemName: "info.square.fill", withConfiguration: addImageConfig2)
            informationButton.setImage(addImage2, for: .normal)
            
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
