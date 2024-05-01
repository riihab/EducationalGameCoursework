//
//  GameOverView.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 11/12/2023.
//

import Foundation
import UIKit
import DGCharts

class GameOverView : UIView {
    
    var hasLayoutSubviewsBeenCalled = false
    var layoutSubviewsCompletion: (() -> Void)?
    
    let title = UILabel()
    let scoreLabel = UILabel()
    let highscoreLabel = UILabel()
    let wrongLabel = UILabel()
    
    let tryAgainButton = UIButton()
    let returnToMenuButton = UIButton()
    
    var chartView = LineChartView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 1
        addSubview(title)
        title.accessibilityLabel = "Game over"
        
        scoreLabel.textAlignment = .center
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.numberOfLines = 1
        addSubview(scoreLabel)
        
        highscoreLabel.textAlignment = .center
        highscoreLabel.adjustsFontSizeToFitWidth = true
        highscoreLabel.numberOfLines = 1
        addSubview(highscoreLabel)
        
        tryAgainButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        tryAgainButton.tintColor = .white.withAlphaComponent(0.5)
        tryAgainButton.isEnabled = true
        tryAgainButton.isExclusiveTouch = true
        tryAgainButton.adjustsImageWhenHighlighted = false
        tryAgainButton.imageView?.contentMode = .scaleAspectFit
        tryAgainButton.contentHorizontalAlignment = .center
        tryAgainButton.titleLabel?.adjustsFontSizeToFitWidth = true
        tryAgainButton.titleLabel?.numberOfLines = 1
        tryAgainButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        tryAgainButton.layer.borderWidth = 5
        tryAgainButton.tag = 1
        addSubview(tryAgainButton)
        tryAgainButton.accessibilityLabel = "Try again"
        
        returnToMenuButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        returnToMenuButton.tintColor = .white.withAlphaComponent(0.5)
        returnToMenuButton.isEnabled = true
        returnToMenuButton.isExclusiveTouch = true
        returnToMenuButton.adjustsImageWhenHighlighted = false
        returnToMenuButton.imageView?.contentMode = .scaleAspectFit
        returnToMenuButton.contentHorizontalAlignment = .center
        returnToMenuButton.titleLabel?.adjustsFontSizeToFitWidth = true
        returnToMenuButton.titleLabel?.numberOfLines = 1
        returnToMenuButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        returnToMenuButton.layer.borderWidth = 5
        returnToMenuButton.tag = 2
        addSubview(returnToMenuButton)
        returnToMenuButton.accessibilityLabel = "Return to menu"
        
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        addSubview(chartView)
        
        wrongLabel.textAlignment = .center
        wrongLabel.adjustsFontSizeToFitWidth = true
        wrongLabel.numberOfLines = 2
        //        wrongLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.35).cgColor
        //        wrongLabel.layer.borderColor = UIColor.white.withAlphaComponent(0.35).cgColor
        //        wrongLabel.layer.borderWidth = 2
        addSubview(wrongLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLayoutSubviewsBeenCalled {
            hasLayoutSubviewsBeenCalled = true
            
            let height = superview?.frame.height ?? 0
            let width = superview?.frame.width ?? 0
            
            title.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.75, height: self.bounds.height*0.175)
            title.center.x = self.bounds.width*0.5
            title.center.y = self.bounds.height*0.125
            title.layer.cornerRadius = self.bounds.height*0.03125
            let attributeTitle = Attribute.outlineUnder(string: "Game Over!", font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            title.attributedText = attributeTitle
            
            scoreLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.1)
            scoreLabel.center.x = self.bounds.width*0.5
            scoreLabel.center.y = self.bounds.height*0.245
            scoreLabel.layer.cornerRadius = self.bounds.height*0.03125
            let attributeTitle2 = Attribute.outline(string: "Score: 0", font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            scoreLabel.attributedText = attributeTitle2
            
            highscoreLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.1)
            highscoreLabel.center.x = self.bounds.width*0.5
            highscoreLabel.center.y = self.bounds.height*0.285
            highscoreLabel.layer.cornerRadius = self.bounds.height*0.03125
            let attributeTitle3 = Attribute.outline(string: "Previous Best: 0", font: FontKit.roundedFont(ofSize: self.bounds.height*0.025, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            highscoreLabel.attributedText = attributeTitle3
            
            tryAgainButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            tryAgainButton.center.x = width*0.5
            tryAgainButton.center.y = height*0.75
            tryAgainButton.layer.cornerRadius = height*0.0225
            let attributeAddButton = Attribute.outline(string: "Try Again", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            tryAgainButton.setAttributedTitle(attributeAddButton, for: .normal)
            
            returnToMenuButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            returnToMenuButton.center.x = width*0.5
            returnToMenuButton.center.y = height*0.85
            returnToMenuButton.layer.cornerRadius = height*0.0225
            let attributeSubButton = Attribute.outline(string: "Return to Menu", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            returnToMenuButton.setAttributedTitle(attributeSubButton, for: .normal)
            
            chartView.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.25)
            chartView.center.x = self.bounds.width*0.5
            chartView.center.y = self.bounds.height*0.45
            //            chartView.layer.cornerRadius = self.bounds.height*0.03125
            
            wrongLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.85, height: self.bounds.height*0.1)
            wrongLabel.center.x = self.bounds.width*0.5
            wrongLabel.center.y = self.bounds.height*0.64
            wrongLabel.layer.cornerRadius = self.bounds.height*0.03125
            let attributeTitle4 = Attribute.outline(string: "You got 0 questions wrong", font: FontKit.roundedFont(ofSize: self.bounds.height*0.025, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            let attributeTitle5 = Attribute.outline(string: "\nThat's an A+!!!", font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            attributeTitle4.append(attributeTitle4)
            wrongLabel.attributedText = attributeTitle4
            
            layoutSubviewsCompletion?()
        }
        
    }
    
    @objc func setupLineChart(highArray: [Double], wrongArray: [Double]) {
        
        // an array of data entries
        var entries: [ChartDataEntry] = []
        for i in 0..<highArray.count {
            let entry = ChartDataEntry(x: Double(i), y: highArray[i])
            entries.insert(entry, at: i)
        }
        
        var entries2: [ChartDataEntry] = []
        for i in 0..<wrongArray.count {
            let entry2 = ChartDataEntry(x: Double(i), y: wrongArray[i])
            entries2.insert(entry2, at: i)
        }
        
        // a data set with the entries
        let dataSet = LineChartDataSet(entries: entries, label: "Correct     ")
        dataSet.colors = [NSUIColor.black]
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 3.0
        dataSet.circleRadius = 10.0
        dataSet.circleColors = [NSUIColor.black]
        dataSet.valueFont = FontKit.roundedFont(ofSize: self.bounds.height*0.0125, weight: .bold) // UIFont.systemFont(ofSize: 12)
        dataSet.valueColors = [NSUIColor.black]
        dataSet.valueTextColor = .clear
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = false
        
        // a data set with the entries
        let dataSet2 = LineChartDataSet(entries: entries2, label: "Incorrect     ")
        dataSet2.colors = [NSUIColor.systemRed]
        dataSet2.mode = .cubicBezier
        dataSet2.lineWidth = 3.0
        dataSet2.circleRadius = 10.0
        dataSet2.circleColors = [NSUIColor.systemRed]
        dataSet2.valueFont = FontKit.roundedFont(ofSize: self.bounds.height*0.0125, weight: .bold) // UIFont.systemFont(ofSize: 12)
        dataSet2.valueColors = [NSUIColor.systemRed]
        dataSet2.valueTextColor = .clear
        dataSet2.drawCircleHoleEnabled = false
        dataSet2.drawCirclesEnabled = false
        
        let data = LineChartData(dataSets: [dataSet, dataSet2])
        chartView.data = data
        chartView.gridBackgroundColor = UIColor.clear
        
        chartView.leftAxis.labelTextColor = UIColor.black
        chartView.leftAxis.axisLineColor = UIColor.black
        chartView.leftAxis.axisLineWidth = 4
        chartView.leftAxis.labelFont = FontKit.roundedFont(ofSize: self.bounds.height*0.015, weight: .bold)
        chartView.leftAxis.gridColor = UIColor.clear
        
        chartView.legend.textColor = UIColor.black
        chartView.legend.horizontalAlignment = .left
        chartView.legend.font = FontKit.roundedFont(ofSize: self.bounds.height*0.015, weight: .bold)
        
        //        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 0.0)
        
        chartView.leftAxis.enabled = true
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        
        chartView.legend.enabled = true
        
        chartView.clipDataToContentEnabled = false
        
        chartView.dragEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.highlightPerTapEnabled = false
        
        chartView.chartDescription.text = "Previous Scores"
    }
    
    // adds confetti for beating high score
    @objc func beatHighScore() {
        SPConfettiConfiguration.particlesConfig.colors = [.systemRed, .systemOrange, .systemYellow, .systemPink, .systemPurple, .systemBlue, .systemCyan]
        SPConfetti.startAnimating(.fullWidthToDown, particles: [.arc], duration: 3)
    }
    
    // shows the score and high score
    @objc func setScore(score: Int, highscore: Int, currentLevel: Int, currentDifficulty: Int, wrongAnswerCount: Int) {
        
        var level = "Addition"
        switch currentLevel {
        case 1: level = "Addition"
        case 2: level = "Subtraction"
        case 3: level = "Multiplication"
        case 4: level = "Division"
        default: print("Unknown Level")
        }
        
        var difficulty = "Easy"
        var expectedScore = 40
        switch currentDifficulty {
        case 1: difficulty = "Easy"; expectedScore = 40
        case 2: difficulty = "Medium"; expectedScore = 30
        case 3: difficulty = "Hard"; expectedScore = 20
        default: print("Unknown Difficulty")
        }
        
        scoreLabel.text = "Score: \(score)"
        highscoreLabel.text = "\(level) \(difficulty) Best: \(highscore)"
        
        //        var wrongGrade = "an A+!!!"
        //        switch wrongAnswerCount {
        //        case 0: wrongGrade = "an A+!!!"
        //        case 1...2: wrongGrade = "an A!!"
        //        case 3...4: wrongGrade = "a B!"
        //        case 5...: wrongGrade = "a C!"
        //        default: print("Unknown grade")
        //        }
        //
        //        var questionText = "questions"
        //        if wrongAnswerCount == 1 {
        //            questionText = "question"
        //        }
        
        //        let attributeTitle = Attribute.outline(string: "You got \(wrongAnswerCount) \(questionText) wrong", font: FontKit.roundedFont(ofSize: self.bounds.height*0.025, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
        //        let attributeTitle2 = Attribute.outline(string: "\nThat's \(wrongGrade)", font: FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
        //        attributeTitle.append(attributeTitle2)
        //        wrongLabel.attributedText = attributeTitle
        
        
        let percentage : Double = (Double(score)/Double(expectedScore))
        print(percentage)
        var grade = "an A+!!"
        switch percentage {
        case 0...0.2: grade = "an E!"
        case 0.2...0.4: grade = "a D!"
        case 0.4...0.6: grade = "a C!"
        case 0.6...0.8: grade = "a B!"
        case 0.8...1.0: grade = "a A!"
        case 1.0...: grade = "a A+!!"
        default: print("Unknown grade")
        }
        
        let attributeTitle = Attribute.outline(string: "Expected score: \(expectedScore)", font: FontKit.roundedFont(ofSize: self.bounds.height*0.025, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
        let attributeTitle2 = Attribute.outlineUnder(string: "\nYou got \(score)/\(expectedScore) - That's \(grade)", font: FontKit.roundedFont(ofSize: self.bounds.height*0.025, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
        attributeTitle.append(attributeTitle2)
        wrongLabel.attributedText = attributeTitle
        
        scoreLabel.accessibilityLabel = "Score: \(score)"
        highscoreLabel.accessibilityLabel = "\(level) \(difficulty) Best: \(highscore)"
        wrongLabel.accessibilityLabel = "You got \(wrongAnswerCount) questions wrong. That's \(grade)"
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
        case 1: symbol = ["plus.circle.fill", "flag.checkered.2.crossed"]
        case 2: symbol = ["minus.circle.fill", "flag.checkered.2.crossed"]
        case 3: symbol = ["multiply.circle.fill", "flag.checkered.2.crossed"]
        case 4: symbol = ["divide.circle.fill", "flag.checkered.2.crossed"]
        default: print("Unknown Level")
        }
        
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
