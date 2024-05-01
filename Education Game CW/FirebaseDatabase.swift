//
//  FirebaseDatabase.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 25/03/2024.
//

import Foundation
import FirebaseDatabase
import UIKit

class FirebaseDatabase {
    
    var ref: DatabaseReference!
    
    var defaults = UserDefaults.standard
    //    var username = ""
    
    func configureDatabase() {
        // Set the database reference
        ref = Database.database().reference()
        
        // Write data to the database
        //        ref.child("example").setValue(["name": "Firebase"])
        
        // Read data from the database
        //        ref.child("example").observeSingleEvent(of: .value, with: { snapshot in
        //            let value = snapshot.value as? NSDictionary
        //            let name = value?["name"] as? String ?? ""
        //            print("Name: \(name)")
        //        }) { error in
        //            print(error.localizedDescription)
        //        }
    }
    
    func checkAndCreateUser(username: String, password: String, theme: String, settings: [Bool], allScores: [[Int]], allWrongScores: [[Int]], askedQuestions: [[[Int]]], completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        
        ref.child("users").child(username).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                print("Username already exists. Choose a different username.")
                completion(false)
            } else {
                self.createUser(username: username, password: password, theme: theme, settings: settings, allScores: allScores, allWrongScores: allWrongScores, askedQuestions: askedQuestions) { success in
                    completion(success)
                }
            }
        }) { error in
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func createUser(username: String, password: String, theme: String, settings: [Bool], allScores: [[Int]], allWrongScores: [[Int]], askedQuestions: [[[Int]]], completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        
        let userData = [
            "password": password,
            "theme": theme,
            "settings": settings,
            "allScores": allScores,
            "allWrongScores": allWrongScores,
            "askedQuestions": askedQuestions
        ] as [String: Any]
        
        ref.child("users").child(username).setValue(userData) { error, _ in
            if let error = error {
                print("Data could not be saved: \(error).")
                completion(false)
            } else {
                print("User data saved successfully for username \(username)!")
                
                //                let theme = ""
                //                let settings = [false,true,true,true,true]
                //                let allScores : [[Int]] = [[], [], [], [], [], [], [], [], [], [], [], []]
                //                let allWrongScores : [[Int]] = [[], [], [], [], [], [], [], [], [], [], [], []]
                //                let askedQuestions : [[Int]] = [[], [], [], []]
                self.updateUserDefaults(theme: theme, settings: settings, allScores: allScores, allWrongScores: allWrongScores, askedQuestions: askedQuestions)
                self.defaults.set(username, forKey: "username")
                
                completion(true)
            }
        }
    }
    
    func loginUser(withUsername username: String, andPassword password: String, completion: @escaping (Bool) -> Void) {
        // Reference to the Firebase Real-Time Database
        let ref = Database.database().reference()
        
        // Navigate to the user's data using the username
        ref.child("users").child(username).observeSingleEvent(of: .value, with: { snapshot in
            // Check if user exists
            guard let user = snapshot.value as? [String: Any] else {
                print("User not found")
                completion(false)  // User not found, return false
                return
            }
            
            // Extract password from the user's data
            if let storedPassword = user["password"] as? String, storedPassword == password {
                // Passwords match, login successful
                print("Login successful for user: \(username)")
                
                let theme = user["theme"] as? String ?? ""
                let settings = user["settings"] as? [Bool] ?? [false,true,true,true,true]
                let allScores = user["allScores"] as? [[Int]] ?? [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]]
                let allWrongScores = user["allWrongScores"] as? [[Int]] ?? [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]]
                let askedQuestions = user["askedQuestions"] as? [[[Int]]] ?? [[[0,0]], [[0,0]], [[0,0]], [[0,0]]]
                self.updateUserDefaults(theme: theme, settings: settings, allScores: allScores, allWrongScores: allWrongScores, askedQuestions: askedQuestions)
                self.defaults.set(username, forKey: "username")
                print(allScores)
                completion(true)  // Login successful, return true
            } else {
                // Passwords do not match
                print("Incorrect password for user: \(username)")
                completion(false)  // Incorrect password, return false
            }
        }) { error in
            print(error.localizedDescription)
            completion(false)  // On error, return false
        }
    }
    
    //    func fetchUserData(userID: String) {
    //        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
    //            // Check if user data exists
    //            guard let value = snapshot.value as? [String: AnyObject] else {
    //                print("User data not found")
    //                return
    //            }
    //
    //            let username = value["username"] as? String ?? ""
    //            let theme = value["theme"] as? String ?? ""
    //            let settings = value["settings"] as? [Bool] ?? []
    //            let additionalScores = value["additionalScores"] as? [Int] ?? []
    //
    //            // Use this data in your app as needed
    //            print("Username: \(username), Theme: \(theme), settings: \(settings), Additional Scores: \(additionalScores)")
    //
    //        }) { (error) in
    //            print(error.localizedDescription)
    //        }
    //    }
    
    //    func updateThemeForUser(userID: String, theme: String) {
    //        let username = self.defaults.string(forKey: "username") ?? ""
    //        ref.child("users").child(username).updateChildValues(["theme": theme]) { (error, ref) in
    //            if let error = error {
    //                print("Data could not be saved: \(error).")
    //            } else {
    //                print("Data saved successfully!")
    //            }
    //        }
    //    }
    
    //    func updateUserTheme(theme: String, completion: @escaping (Bool) -> Void) {
    //        let ref = Database.database().reference()
    //
    //        let username = self.defaults.string(forKey: "username") ?? ""
    //
    //        // Navigate to the user's data using the username
    //        ref.child("users").child(username).observeSingleEvent(of: .value, with: { snapshot in
    //            // Check if user exists
    //            guard let user = snapshot.value as? [String: Any] else {
    //                print("User not found")
    //                completion(false)  // User not found, return false
    //                return
    //            }
    //
    //                let userData = [
    //                    "theme": theme
    //                ] as [String: Any]
    //
    //                ref.child("users").child(username).updateChildValues(userData) { error, _ in
    //                        if let error = error {
    //                            print("Error updating user: \(error.localizedDescription)")
    //                            completion(false)  // Update failed
    //                        } else {
    //                            print("User successfully updated.")
    //                            completion(true)  // Update succeeded
    //                        }
    //                    }
    //
    //        }) { error in
    //            print(error.localizedDescription)
    //            completion(false)  // On error, return false
    //        }
    //    }
    
    func updateUser(theme: String? = nil, settings: [Bool]? = nil, allScoresCurrent: [Int]? = nil, allWrongScoresCurrent: [Int]? = nil, askedQuestionsCurrent: [[Int]]? = nil, location: Int? = nil, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        
        let username = self.defaults.string(forKey: "username") ?? ""
        
        // Navigate to the user's data using the username
        ref.child("users").child(username).observeSingleEvent(of: .value, with: { snapshot in
            // Check if user exists
            guard let user = snapshot.value as? [String: Any] else {
                print("User not found")
                completion(false)  // User not found, return false
                return
            }
            
            var userData = [String: Any]()
            
            if let theme = theme {
                userData["theme"] = theme
            }
            if let settings = settings {
                userData["settings"] = settings
            }
            if let allScoresCurrent = allScoresCurrent {
                
                var allScores = user["allScores"] as? [[Int]] ?? [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]]
                if let location = location {
                    allScores[location] = allScoresCurrent
                }
                userData["allScores"] = allScores
            }
            if let allWrongScoresCurrent = allWrongScoresCurrent {
                var allWrongScores = user["allWrongScores"] as? [[Int]] ?? [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]]
                if let location = location {
                    allWrongScores[location] = allWrongScoresCurrent
                }
                userData["allWrongScores"] = allWrongScores
            }
            if let askedQuestionsCurrent = askedQuestionsCurrent {
                var askedQuestions = user["askedQuestions"] as? [[[Int]]] ?? [[[0,0]], [[0,0]], [[0,0]], [[0,0]]]
                if let location = location {
                    askedQuestions[location] = askedQuestionsCurrent
                }
                userData["askedQuestions"] = askedQuestions
            }
            
            ref.child("users").child(username).updateChildValues(userData) { error, _ in
                if let error = error {
                    print("Error updating user: \(error.localizedDescription)")
                    completion(false)  // Update failed
                } else {
                    print("User successfully updated.")
                    completion(true)  // Update succeeded
                }
            }
            //                completion(true)
            
        }) { error in
            print(error.localizedDescription)
            completion(false)  // On error, return false
        }
    }
    
    func updateUserDefaults(theme: String, settings: [Bool], allScores: [[Int]], allWrongScores: [[Int]], askedQuestions: [[[Int]]]) {
        
        self.defaults.set(settings[0], forKey: "isSpeechOn")
        self.defaults.set(settings[1], forKey: "isHeadMovementOn")
        self.defaults.set(settings[2], forKey: "isMotionOn")
        self.defaults.set(settings[3], forKey: "isHapticsOn")
        self.defaults.set(settings[4], forKey: "isCoinsOn")
        
        self.defaults.setColor(color: color(from: theme), forKey: "themeColour")
        
        self.defaults.set(allScores[0], forKey: "highscoreArray\(1)\(1)")
        self.defaults.set(allScores[1], forKey: "highscoreArray\(1)\(2)")
        self.defaults.set(allScores[2], forKey: "highscoreArray\(1)\(3)")
        self.defaults.set(allScores[3], forKey: "highscoreArray\(2)\(1)")
        self.defaults.set(allScores[4], forKey: "highscoreArray\(2)\(2)")
        self.defaults.set(allScores[5], forKey: "highscoreArray\(2)\(3)")
        self.defaults.set(allScores[6], forKey: "highscoreArray\(3)\(1)")
        self.defaults.set(allScores[7], forKey: "highscoreArray\(3)\(2)")
        self.defaults.set(allScores[8], forKey: "highscoreArray\(3)\(3)")
        self.defaults.set(allScores[9], forKey: "highscoreArray\(4)\(1)")
        self.defaults.set(allScores[10],forKey: "highscoreArray\(4)\(2)")
        self.defaults.set(allScores[11],forKey: "highscoreArray\(4)\(3)")
        
        self.defaults.set(allWrongScores[0], forKey: "wrongArray\(1)\(1)")
        self.defaults.set(allWrongScores[1], forKey: "wrongArray\(1)\(2)")
        self.defaults.set(allWrongScores[2], forKey: "wrongArray\(1)\(3)")
        self.defaults.set(allWrongScores[3], forKey: "wrongArray\(2)\(1)")
        self.defaults.set(allWrongScores[4], forKey: "wrongArray\(2)\(2)")
        self.defaults.set(allWrongScores[5], forKey: "wrongArray\(2)\(3)")
        self.defaults.set(allWrongScores[6], forKey: "wrongArray\(3)\(1)")
        self.defaults.set(allWrongScores[7], forKey: "wrongArray\(3)\(2)")
        self.defaults.set(allWrongScores[8], forKey: "wrongArray\(3)\(3)")
        self.defaults.set(allWrongScores[9], forKey: "wrongArray\(4)\(1)")
        self.defaults.set(allWrongScores[10],forKey: "wrongArray\(4)\(2)")
        self.defaults.set(allWrongScores[11],forKey: "wrongArray\(4)\(3)")
        
        self.defaults.set(allScores[0].max() ?? 0, forKey: "highscore\(1)\(1)")
        self.defaults.set(allScores[1].max() ?? 0, forKey: "highscore\(1)\(2)")
        self.defaults.set(allScores[2].max() ?? 0, forKey: "highscore\(1)\(3)")
        self.defaults.set(allScores[3].max() ?? 0, forKey: "highscore\(2)\(1)")
        self.defaults.set(allScores[4].max() ?? 0, forKey: "highscore\(2)\(2)")
        self.defaults.set(allScores[5].max() ?? 0, forKey: "highscore\(2)\(3)")
        self.defaults.set(allScores[6].max() ?? 0, forKey: "highscore\(3)\(1)")
        self.defaults.set(allScores[7].max() ?? 0, forKey: "highscore\(3)\(2)")
        self.defaults.set(allScores[8].max() ?? 0, forKey: "highscore\(3)\(3)")
        self.defaults.set(allScores[9].max() ?? 0, forKey: "highscore\(4)\(1)")
        self.defaults.set(allScores[10].max() ?? 0,forKey: "highscore\(4)\(2)")
        self.defaults.set(allScores[11].max() ?? 0,forKey: "highscore\(4)\(3)")
        
        // crashes as doesnt exist
        self.defaults.set(askedQuestions[0], forKey: "askedQuestions\(1)")
        self.defaults.set(askedQuestions[1], forKey: "askedQuestions\(2)")
        self.defaults.set(askedQuestions[2], forKey: "askedQuestions\(3)")
        self.defaults.set(askedQuestions[3], forKey: "askedQuestions\(4)")
        
        self.defaults.synchronize()
        print(allScores)
    }
    
    func color(from string: String) -> UIColor? {
        let components = string
            .replacingOccurrences(of: "red: ", with: "")
            .replacingOccurrences(of: "green: ", with: "")
            .replacingOccurrences(of: "blue: ", with: "")
            .replacingOccurrences(of: "alpha: ", with: "")
            .components(separatedBy: ", ")
            .compactMap { CGFloat(Double($0) ?? 0) }
        
        guard components.count == 4 else { return nil }
        
        return UIColor(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
    
}
