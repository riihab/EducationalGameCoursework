//
//  SmallStatisticsView.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 31/03/2024.
//

import Foundation
import UIKit
import DGCharts

class SmallStatisticsView : UIView {
    
    var hasLayoutSubviewsBeenCalled = false
    var layoutSubviewsCompletion: (() -> Void)?
    
    let title = UILabel()
    var chartView = LineChartView()
    let highscoreLabel = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 1
        addSubview(title)
        
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        addSubview(chartView)
        
        highscoreLabel.textAlignment = .center
        highscoreLabel.adjustsFontSizeToFitWidth = true
        highscoreLabel.numberOfLines = 1
        addSubview(highscoreLabel)
        
        self.clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLayoutSubviewsBeenCalled {
            hasLayoutSubviewsBeenCalled = true
            
            //            let height = superview?.frame.height ?? 0
            //            let width = superview?.frame.width ?? 0
            
            self.layer.cornerRadius = self.bounds.height*0.075
            self.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            self.layer.borderWidth = 5
            
            highscoreLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.1)
            highscoreLabel.center.x = self.bounds.width*0.5
            highscoreLabel.center.y = self.bounds.height*0.1
            //            highscoreLabel.layer.cornerRadius = self.bounds.height*0.03125
            //            let attributeTitle3 = Attribute.outline(string: "Previous Best: 0", font: FontKit.roundedFont(ofSize: self.bounds.height*0.1, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            //            highscoreLabel.attributedText = attributeTitle3
            
            title.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.1)
            title.center.x = self.bounds.width*0.5
            title.center.y = self.bounds.height*0.2
            
            chartView.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.9, height: self.bounds.height*0.7)
            chartView.center.x = self.bounds.width*0.5
            chartView.center.y = self.bounds.height*0.6
            //            chartView.layer.cornerRadius = self.bounds.height*0.03125
            
            layoutSubviewsCompletion?()
        }
        
    }
    
    // shows the score and high score
    @objc func setScore(highscore: Int, currentLevel: Int, currentDifficulty: Int) {
        
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
        
        //        highscoreLabel.text = "\(level) \(difficulty) Best: \(highscore)"
        let attributeTitle3 = Attribute.outlineUnder(string: "\(level) \(difficulty)", font: FontKit.roundedFont(ofSize: self.bounds.height*0.075, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black) //  Best: \(highscore)
        highscoreLabel.attributedText = attributeTitle3
        highscoreLabel.accessibilityLabel = "\(level) \(difficulty)" //  Best: \(highscore)
        highscoreLabel.textAlignment = .left
        
        let percentage : Double = (Double(highscore)/Double(expectedScore))
        print(percentage)
        var grade = "A+"
        switch percentage {
        case 0...0.2: grade = "E"
        case 0.2...0.4: grade = "D"
        case 0.4...0.6: grade = "C"
        case 0.6...0.8: grade = "B"
        case 0.8...1.0: grade = "A"
        case 1.0...: grade = "A+"
        default: print("Unknown grade")
        }
        
        let attributeTitle = Attribute.outline(string: "Highest grade:  ", font: FontKit.roundedFont(ofSize: self.bounds.height*0.09, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
        let attributeTitle2 = Attribute.outlineUnder(string: "\(grade)", font: FontKit.roundedFont(ofSize: self.bounds.height*0.1, weight: .heavy), outlineSize: 0, textColor: .black, outlineColor: .black)
        attributeTitle.append(attributeTitle2)
        title.attributedText = attributeTitle
        title.accessibilityLabel = "Highest grade: \(grade)"
        
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
        chartView.leftAxis.labelFont = FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .bold)
        chartView.leftAxis.gridColor = UIColor.clear
        
        chartView.legend.textColor = UIColor.black
        chartView.legend.horizontalAlignment = .left
        chartView.legend.font = FontKit.roundedFont(ofSize: self.bounds.height*0.05, weight: .bold)
        
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
