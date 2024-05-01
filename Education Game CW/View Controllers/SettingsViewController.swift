//
//  SettingsViewController.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 04/02/2024.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIColorPickerViewControllerDelegate {
    
    var firebaseDatabase = FirebaseDatabase()
    
    var settingsView = SettingsView()
    var isFromLaunch: Bool?
    
    var defaults = UserDefaults.standard
    var appOpenCount = 0
    
    var isSpeechOn = true
    var isHapticsOn = true
    var isHeadMovementOn = true
    var isMotionOn = true
    var isCoinsOn = true
    
    let picker = colorPicker()
    var themeColour = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        firebaseDatabase.configureDatabase()
        
        picker.delegate = self
        picker.supportsAlpha = true
        
        let titleLabel = UILabel()
        titleLabel.text = "Settings"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        self.appOpenCount = self.defaults.value(forKey: "appOpenCount") as? Int ?? 0
        
        //        self.defaults.register(defaults: ["themeColour" : UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))])
        self.themeColour = self.defaults.colorForKey(key: "themeColour") ?? UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))
        
        self.defaults.register(defaults: ["isSpeechOn" : true])
        self.defaults.register(defaults: ["isHeadMovementOn" : true])
        self.defaults.register(defaults: ["isMotionOn" : true])
        self.defaults.register(defaults: ["isHapticsOn" : true])
        self.defaults.register(defaults: ["isCoinsOn" : true])
        
        self.isSpeechOn = self.defaults.bool(forKey: "isSpeechOn")
        self.isHeadMovementOn = self.defaults.bool(forKey: "isHeadMovementOn")
        self.isMotionOn = self.defaults.bool(forKey: "isMotionOn")
        self.isHapticsOn = self.defaults.bool(forKey: "isHapticsOn")
        self.isCoinsOn = self.defaults.bool(forKey: "isCoinsOn")
        
        self.defaults.set(self.isSpeechOn, forKey: "isSpeechOn")
        self.defaults.set(self.isHeadMovementOn, forKey: "isHeadMovementOn")
        self.defaults.set(self.isMotionOn, forKey: "isMotionOn")
        self.defaults.set(self.isHapticsOn, forKey: "isHapticsOn")
        self.defaults.set(self.isCoinsOn, forKey: "isCoinsOn")
        self.defaults.synchronize()
        
        view.backgroundColor = UIColor.white
        
        settingsView = SettingsView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        settingsView.center.x = view.bounds.width*0.5
        settingsView.center.y = view.bounds.height*0.5
        settingsView.alpha = 0
        view.addSubview(settingsView)
        
        settingsView.layoutSubviewsCompletion = {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
                self.settingsView.alpha = 1
                self.settingsView.backgroundColor = self.themeColour
            }, completion: nil)
            
            self.settingsView.backgroundAnimation()
        }
        
        settingsView.colourButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        settingsView.colourButton.addTarget(self, action: #selector(pickColour (_:)), for: .touchUpInside)
        settingsView.colourButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        settingsView.logOutButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        settingsView.logOutButton.addTarget(self, action: #selector(logOut (_:)), for: .touchUpInside)
        settingsView.logOutButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        settingsView.backButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        settingsView.backButton.addTarget(self, action: #selector(returnAction(_:)), for: .touchUpInside)
        settingsView.backButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        settingsView.settingsTableView.dataSource = self
        settingsView.settingsTableView.delegate = self
    }
    
    // opens colour picker and shows currently selected colour
    @objc func pickColour(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent,.allowUserInteraction], animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: nil)
        
        present(picker, animated: true, completion: nil)
        
        picker.selectedColor = themeColour
    }
    
    @objc func logOut(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent,.allowUserInteraction], animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: nil)
        
        let loginViewController = LoginViewController()
        loginViewController.isFromLaunch = true
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsView.settingsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let setting = settingsView.settingsData[indexPath.row]
        cell.textLabel?.text = setting.0
        cell.textLabel?.textColor = .black
        
        // Set background color of the cell and its content view
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        //        cell.layer.cornerRadius = self.view.bounds.height*0.02
        
        // Add description below the cell
        cell.detailTextLabel?.text = setting.1
        cell.detailTextLabel?.textColor = .black
        cell.detailTextLabel?.numberOfLines = 0 // Allow multiple lines for the description
        
        cell.textLabel?.font = FontKit.roundedFont(ofSize: self.view.bounds.height*0.0175, weight: .heavy)
        cell.detailTextLabel?.font = FontKit.roundedFont(ofSize: self.view.bounds.height*0.0175, weight: .semibold)
        
        if indexPath.row != 3 {
            let switchControl = UISwitch()
            switchControl.tag = indexPath.row
            switchControl.onTintColor = UIColor.black
            switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchControl
            
            if indexPath.row == 0 && isSpeechOn == true {
                switchControl.isOn = true
            } else if indexPath.row == 1 && isHeadMovementOn == true {
                switchControl.isOn = true
            } else if indexPath.row == 2 && isMotionOn == true {
                switchControl.isOn = true
            } else if indexPath.row == 4 && isHapticsOn == true {
                switchControl.isOn = true
            } else if indexPath.row == 5 && isCoinsOn == true {
                switchControl.isOn = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            var height:CGFloat = CGFloat()
            height = 10
            return height
        } else {
            return tableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle selection if needed
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        // Handle switch value changed event
        if sender.tag == 0 {
            self.defaults.set(sender.isOn, forKey: "isSpeechOn")
            self.defaults.synchronize()
        } else if sender.tag == 1 {
            self.defaults.set(sender.isOn, forKey: "isHeadMovementOn")
            self.defaults.synchronize()
        } else if sender.tag == 2 {
            self.defaults.set(sender.isOn, forKey: "isMotionOn")
            self.defaults.synchronize()
        } else if sender.tag == 4 {
            self.defaults.set(sender.isOn, forKey: "isHapticsOn")
            self.defaults.synchronize()
        } else if sender.tag == 5 {
            self.defaults.set(sender.isOn, forKey: "isCoinsOn")
            self.defaults.synchronize()
        }
        
        self.isSpeechOn = self.defaults.bool(forKey: "isSpeechOn")
        self.isHeadMovementOn = self.defaults.bool(forKey: "isHeadMovementOn")
        self.isMotionOn = self.defaults.bool(forKey: "isMotionOn")
        self.isHapticsOn = self.defaults.bool(forKey: "isHapticsOn")
        self.isCoinsOn = self.defaults.bool(forKey: "isCoinsOn")
        
        self.firebaseDatabase.updateUser(settings: [isSpeechOn, isHeadMovementOn, isMotionOn, isHapticsOn, isCoinsOn]) { isSuccess in
            if isSuccess {
                print("success saved settings")
            } else {
                print("failed to save settings")
            }
        }
        
    }
    
    // when tapping on a level
    @objc func returnAction(_ sender: UIButton) {
        settingsView.buttonExit(sender)
        
        let menuViewController = MenuViewController()
        menuViewController.isFromLaunch = false
        menuViewController.modalPresentationStyle = .overFullScreen
        present(menuViewController, animated: true)
    }
    
    // when completing a button press
    @objc func buttonUp(_ sender: UIButton) {
        settingsView.buttonExit(sender)
    }
    
    // when canceling a button press
    @objc func buttonExit(_ sender: UIButton) {
        settingsView.buttonExit(sender)
    }
    
    // when pressing a button
    @objc func buttonDown(_ sender: UIButton) {
        settingsView.buttonDown(sender)
    }
    
    // restart the background animation when entering the app again
    @objc func didEnterForeground(_ notification: Notification) {
        settingsView.backgroundAnimation()
    }
    
    // sets the status bar colour
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // called when closing the colour picker
    @objc func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        //        dismiss(animated: true, completion: nil)
        
        let color : CGColor = viewController.selectedColor.cgColor
        let colorRed : CGFloat = CGFloat(Float(color.components?[0] ?? 1.0))
        let colorGreen : CGFloat = CGFloat(Float(color.components?[1] ?? 1.0))
        let colorBlue : CGFloat = CGFloat(Float(color.components?[2] ?? 1.0))
        let colorAlpha : CGFloat = CGFloat(Float(color.components?[3] ?? 1.0))
        themeColour = UIColor(displayP3Red: colorRed, green: colorGreen, blue: colorBlue, alpha: colorAlpha)
        
        self.defaults.setColor(color: themeColour, forKey: "themeColour")
        self.defaults.synchronize()
        
        let saveColor = themeColour.toString()
        self.firebaseDatabase.updateUser(theme: saveColor) { isSuccess in
            if isSuccess {
                print("success saved settings")
            } else {
                print("failed to save settings")
            }
        }
        
        settingsView.backgroundColor = themeColour
    }
    
    @objc func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
    }
    
}

// the colour picker built-in UI
class colorPicker: UIColorPickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
    }
}

// Allows saving of the colour theme
extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var colorReturnded: UIColor?
        if let colorData = data(forKey: key) {
            do {
                if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                    colorReturnded = color
                }
            } catch {
                print("Error UserDefaults")
            }
        }
        return colorReturnded
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
                colorData = data
            } catch {
                print("Error UserDefaults")
            }
        }
        set(colorData, forKey: key)
    }
}

extension UIColor {
    func toString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return "red: \(red), green: \(green), blue: \(blue), alpha: \(alpha)"
    }
}
