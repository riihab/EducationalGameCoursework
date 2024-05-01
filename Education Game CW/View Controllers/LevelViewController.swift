//
//  LevelViewController.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 11/12/2023.
//

import Foundation
import UIKit
import CoreMotion
import Speech
import AVFoundation
import Vision

class LevelViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate  {
    
    var firebaseDatabase = FirebaseDatabase()
    
    var levelView = LevelView()
    var currentLevel: Int?
    
    var captureSession: AVCaptureSession?
    var sequenceHandler = VNSequenceRequestHandler()
    var needsToFaceStraightAgain = false
    
    var audioEngine: AVAudioEngine!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let recognizer = SFSpeechRecognizer()
    var previousRecognizedText = ""
    
    let motionManager = CMMotionManager()
    
    var totalTimer = Timer()
    var questionTimer = Timer()
    
    var totalTime = 60 // 60 seconds
    
    var currentScore = 0
    var wrongAnswerCount = 0
    
    var answer = 0
    var leftText = "0"
    var rightText = "0"
    var isRightCorrect = false
    
    var appOpenCount = 0
    var defaults = UserDefaults.standard
    
    var isPaused = false
    
    var isSpeechOn = true
    var isHeadMovementOn = true
    var isMotionOn = true
    var isHapticsOn = true
    var isCoinsOn = true
    
    var themeColour = UIColor.white
    
    var difficulty = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        firebaseDatabase.configureDatabase()
        
        view.backgroundColor = UIColor.white
        
        levelView = LevelView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        levelView.center.x = view.bounds.width*0.5
        levelView.center.y = view.bounds.height*0.5
        levelView.alpha = 0
        view.addSubview(levelView)
        
        //        self.defaults.register(defaults: ["themeColour" : UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))])
        self.themeColour = self.defaults.colorForKey(key: "themeColour") ?? UIColor(cgColor: CGColor(red: 50/255, green: 1, blue: 120/255, alpha: 1.0))
        self.defaults.synchronize()
        
        levelView.layoutSubviewsCompletion = {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
                self.levelView.alpha = 1
                self.levelView.backgroundColor = self.themeColour
            }, completion: nil)
            //            self.createQuestion()
            
            self.appOpenCount = self.defaults.value(forKey: "appOpenCount") as? Int ?? 0
            self.appOpenCount += 1
            self.defaults.set(self.appOpenCount, forKey: "appOpenCount")
            self.defaults.synchronize()
            
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
            
            if self.isMotionOn {
                self.accelerometerStart()
            }
            
            if self.isHeadMovementOn {
                DispatchQueue.global().async {
                    self.setupCaptureSession()
                }
            }
            
            switch self.appOpenCount {
            case 1:
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                })
                self.howToInfo()
            default:
                //                print("App run count is : \(self.appOpenCount)")
                self.startLevelDifficulty()
                break;
            }
        }
        
        levelView.leftButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        levelView.leftButton.addTarget(self, action: #selector(buttonUp(_:)), for: .touchUpInside)
        levelView.leftButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        levelView.rightButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        levelView.rightButton.addTarget(self, action: #selector(buttonUp(_:)), for: .touchUpInside)
        levelView.rightButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        levelView.pauseButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        levelView.pauseButton.addTarget(self, action: #selector(pause(_:)), for: .touchUpInside)
        levelView.pauseButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
    }
    
    // starts the front camera
    @objc func setupCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            fatalError("No front camera found")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoOutputQueue"))
            captureSession?.addOutput(videoOutput)
            
            captureSession?.startRunning()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // detects a face
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        var requestOptions: [VNImageOption: Any] = [:]
        
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics: cameraIntrinsicData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: requestOptions)
        
        do {
            let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: { request, error in
                if let results = request.results as? [VNFaceObservation] {
                    for face in results {
                        self.analyzeFace(for: face)
                    }
                }
            })
            try imageRequestHandler.perform([detectFaceRequest])
        } catch {
            print("Error processing image request: \(error)")
        }
    }
    
    // function to check and respond to face direction
    @objc func analyzeFace(for face: VNFaceObservation) {
        guard let yaw = face.yaw?.doubleValue else {
            return
        }
        
        if isPaused == false {
            if self.needsToFaceStraightAgain == false {
                if yaw < -0.8 {
                    // Face is facing right
                    print("Face is facing right")
                    self.needsToFaceStraightAgain = true
                    DispatchQueue.main.async {
                        self.answerTapped(buttonSelected: 2)
                    }
                } else if yaw > 0.8 {
                    // Face is facing left
                    print("Face is facing left")
                    self.needsToFaceStraightAgain = true
                    DispatchQueue.main.async {
                        self.answerTapped(buttonSelected: 1)
                    }
                }
            } else if yaw > -0.2 && yaw < 0.2 {
                // Face is facing straight ahead
                print("Face is facing straight ahead")
                self.needsToFaceStraightAgain = false
            }
        }
    }
    
    // starts the level and required functions at the start
    @objc func startLevelDifficulty() {
        isPaused = true
        
        let title = "Choose Difficulty"
        let description = "Harder questions are present at higher difficulties"
        let alert = UIAlertController(title: "\(title)", message: "\(description)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Easy", style: .default, handler: { action in
            switch action.style {
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            default:
                print("default")
                self.difficulty = 1
                self.startLevel()
            }
        }))
        alert.addAction(UIAlertAction(title: "Medium", style: .default, handler: { action in
            switch action.style {
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            default:
                print("default")
                self.difficulty = 2
                self.startLevel()
            }
        }))
        alert.addAction(UIAlertAction(title: "Hard", style: .default, handler: { action in
            switch action.style {
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            default:
                print("default")
                self.difficulty = 3
                self.startLevel()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func startLevel() {
        isPaused = false
        self.createQuestion()
        if self.isSpeechOn == true {
            self.startRecording()
        }
        self.levelView.backgroundAnimation(currentLevel: self.currentLevel ?? 0)
        self.totalTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
    }
    
    // starts recognising motion and acts on it
    @objc func accelerometerStart() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1  // Update interval in seconds
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                guard let acceleration = data?.acceleration else { return }
                
                // Determine movement direction based on accelerometer data
                if acceleration.x > 0.5 {
                    print("Moving Right")
                    if self.isPaused == false {
                        self.answerTapped(buttonSelected: 2)
                    }
                } else if acceleration.x < -0.5 {
                    print("Moving Left")
                    if self.isPaused == false {
                        self.answerTapped(buttonSelected: 1)
                    }
                }
            }
        } else {
            print("Accelerometer data is not available")
        }
    }
    
    // starts recognising audio and acts on it
    @objc func startRecording() {
        audioEngine = AVAudioEngine()
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognizer?.supportsOnDeviceRecognition = true
        
        guard let recognitionRequest = recognitionRequest else { return }
        
        let inputNode = audioEngine.inputNode
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
        
        recognitionTask = recognizer?.recognitionTask(with: recognitionRequest) { result, error in
            // Handle recognition results and errors
            if let result = result {
                //                print(result.bestTranscription.formattedString)
                let newRecognizedText = result.bestTranscription.formattedString
                let newWords = newRecognizedText.replacingOccurrences(of: self.previousRecognizedText, with: "")
                //                print("New words added: \(newWords)")
                self.previousRecognizedText = newRecognizedText
                
                if self.isPaused == false {
                    if newWords.lowercased().contains("left") {
                        print("Word 'Left' detected!")
                        self.answerTapped(buttonSelected: 1)
                    } else if newWords.lowercased().contains("right") {
                        print("Word 'Right' detected!")
                        self.answerTapped(buttonSelected: 2)
                    }
                }
                
            } else if let error = error {
                print("Recognition error: \(error)")
            }
        }
    }
    
    // pauses the game, timer, lets the user return to menu
    @objc func pause(_ sender: UIButton) {
        levelView.buttonExit(sender)
        isPaused = true
        
        let title = "Game Paused"
        let description = "Do you wish to continue playing or return to the menu?"
        let alert = UIAlertController(title: "\(title)", message: "\(description)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue Playing", style: .default, handler: { action in
            switch action.style {
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            default:
                print("default")
                self.isPaused = false
            }
        }))
        alert.addAction(UIAlertAction(title: "Return to Menu", style: .destructive, handler: { action in
            switch action.style {
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
                self.totalTimer.invalidate()
                if self.isSpeechOn == true {
                    self.audioEngine.stop()
                }
                self.recognitionRequest?.endAudio()
                self.recognitionTask?.cancel()
                self.levelView.motionManager.stopDeviceMotionUpdates()
                self.levelView.motionManager.stopAccelerometerUpdates()
                self.motionManager.stopAccelerometerUpdates()
                self.captureSession?.stopRunning()
                
                let askedQuestions = self.defaults.array(forKey: "askedQuestions\(self.currentLevel ?? 0)") as? [[Int]] ?? [[0,0]]
                self.firebaseDatabase.updateUser(askedQuestionsCurrent: askedQuestions, location: (self.currentLevel ?? 1)-1) { isSuccess in
                    if isSuccess {
                        print("success saved asked")
                    } else {
                        print("failed to save asked")
                    }
                }
                
                let menuViewController = MenuViewController()
                menuViewController.modalPresentationStyle = .overFullScreen
                self.present(menuViewController, animated: true)
            default:
                print("default")
            }
        }))
        self.present(alert, animated: true, completion: nil)
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
                self.startLevelDifficulty()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // adjusts possibility of a repeated question based on asked questions
    @objc func randomBoolWithOdds(odds: Int) -> Bool {
        let randomNumber = Int.random(in: 0...(Int(odds/10)+10))
        return randomNumber == 0
    }
    
    // function which creates new questions
    @objc func createQuestion() {
        
        self.defaults.register(defaults: ["askedQuestions\(self.currentLevel ?? 0)" : []])
        var askedQuestions = self.defaults.array(forKey: "askedQuestions\(self.currentLevel ?? 0)") as? [[Int]] ?? [] // saved as [left part of question, and right] in an array e.g. [5,4] = 5 + 4
        
        var questionText = ""
        var isRepeatedQuestion = false
        var a = 0
        var b = 0
        
        var difficultyA = [1,49]
        var difficultyB = [1,49]
        
        if difficulty == 1 { // easy
            switch currentLevel {
            case 1: difficultyA = [1,10]; difficultyB = [1,10]
            case 2: difficultyA = [1,10]; difficultyB = [1,10]
            case 3: difficultyA = [1,5]; difficultyB = [1,5]
            case 4: difficultyA = [1,20]; difficultyB = [2,10]
            default: print("default")
            }
        } else if difficulty == 2 { // medium
            switch currentLevel {
            case 1: difficultyA = [10,20]; difficultyB = [10,20]
            case 2: difficultyA = [10,30]; difficultyB = [10,30]
            case 3: difficultyA = [3,7]; difficultyB = [3,7]
            case 4: difficultyA = [10,40]; difficultyB = [2,10]
            default: print("default")
            }
        } else { // hard
            switch currentLevel {
            case 1: difficultyA = [20,49]; difficultyB = [20,49]
            case 2: difficultyA = [30,99]; difficultyB = [30,99]
            case 3: difficultyA = [1,9]; difficultyB = [1,9]
            case 4: difficultyA = [20,99]; difficultyB = [2,10]
            default: print("default")
            }
        }
        
        if currentLevel == 1 { // addition
            
            var question: [Int]
            if askedQuestions.count >= (((49*49)-1000))/20 {  // if it's asked most questions, then reset the asked questions
                askedQuestions = [[0,0]]
            }
            repeat {
                a = Int.random(in: difficultyA[0]...difficultyA[1]) // used to be 1...49
                b = Int.random(in: difficultyB[0]...difficultyB[1]) // used to be 1...49
                question = [a, b]
                let showRepeatedQuestion = randomBoolWithOdds(odds: askedQuestions.count)
                let randomQuestion = askedQuestions.randomElement()
                if showRepeatedQuestion == true && askedQuestions.count > 1 && (randomQuestion?[0] ?? 0) != 0 { // show repeated question
                    isRepeatedQuestion = true
                    a = randomQuestion?[0] ?? 0
                    b = randomQuestion?[1] ?? 0
                    break
                }
            } while askedQuestions.contains(question) // possible questions = 49 * 49 = 2401
            
            answer = a + b
            questionText = "\(a) + \(b)"
            
            isRightCorrect = Bool.random()
            if isRightCorrect == true {
                rightText = "\(answer)"
                repeat {
                    leftText = "\(answer + Int.random(in: -10...10))"
                } while leftText == rightText || Int(leftText) ?? 0 < 2
            } else {
                leftText = "\(answer)"
                repeat {
                    rightText = "\(answer + Int.random(in: -10...10))"
                } while leftText == rightText || Int(rightText) ?? 0 < 2
            }
        } else if currentLevel == 2 { // subtraction
            
            repeat {
                var question: [Int]
                if askedQuestions.count >= (((99*99)-1000))/20 { // if it's asked most questions, then reset the asked questions
                    askedQuestions = [[0,0]]
                }
                repeat {
                    a = Int.random(in: difficultyA[0]...difficultyA[1]) // used to be 1...99
                    b = Int.random(in: difficultyB[0]...difficultyB[1]) // used to be 1...99
                    question = [a, b]
                    let showRepeatedQuestion = randomBoolWithOdds(odds: askedQuestions.count)
                    let randomQuestion = askedQuestions.randomElement()
                    if showRepeatedQuestion == true && askedQuestions.count > 1 && (randomQuestion?[0] ?? 0) != 0 { // show repeated question
                        isRepeatedQuestion = true
                        a = randomQuestion?[0] ?? 0
                        b = randomQuestion?[1] ?? 0
                        break
                    }
                } while askedQuestions.contains(question) // possible questions = 99 * 99 = 9801
                
                answer = a - b
                questionText = "\(a) - \(b)"
            } while a <= b
            
            isRightCorrect = Bool.random()
            if isRightCorrect == true {
                rightText = "\(answer)"
                repeat {
                    leftText = "\(answer + Int.random(in: -10...10))"
                } while leftText == rightText || Int(leftText) ?? 0 < 2
            } else {
                leftText = "\(answer)"
                repeat {
                    rightText = "\(answer + Int.random(in: -10...10))"
                } while leftText == rightText || Int(rightText) ?? 0 < 2
            }
        } else if currentLevel == 3 { // multiplication
            
            var question: [Int]
            if askedQuestions.count >= (((9*9)-10))/5 { // if it's asked most questions, then reset the asked questions
                askedQuestions = [[0,0]]
            }
            repeat {
                a = Int.random(in: difficultyA[0]...difficultyA[1]) // used to be 1...9
                b = Int.random(in: difficultyB[0]...difficultyB[1]) // used to be 1...9
                question = [a, b]
                let showRepeatedQuestion = randomBoolWithOdds(odds: askedQuestions.count)
                let randomQuestion = askedQuestions.randomElement()
                if showRepeatedQuestion == true && askedQuestions.count > 1 && (randomQuestion?[0] ?? 0) != 0 { // show repeated question
                    isRepeatedQuestion = true
                    a = randomQuestion?[0] ?? 0
                    b = randomQuestion?[1] ?? 0
                    break
                }
            } while askedQuestions.contains(question) // possible questions = 9 * 9 = 81
            
            answer = a * b
            questionText = "\(a) × \(b)"
            
            isRightCorrect = Bool.random()
            if isRightCorrect == true {
                rightText = "\(answer)"
                repeat {
                    leftText = "\(answer + Int.random(in: -10...10))"
                } while leftText == rightText || Int(leftText) ?? 0 < 2
            } else {
                leftText = "\(answer)"
                repeat {
                    rightText = "\(answer + Int.random(in: -10...10))"
                } while leftText == rightText || Int(rightText) ?? 0 < 2
            }
        } else if currentLevel == 4 { // division
            
            repeat {
                var question: [Int]
                if askedQuestions.count >= ((160))/20 { // if it's asked most questions, then reset the asked questions
                    askedQuestions = [[0,0]]
                }
                repeat {
                    a = Int.random(in: difficultyA[0]...difficultyA[1]) // used to be 1...99
                    b = Int.random(in: difficultyB[0]...difficultyB[1]) // used to be 2...10
                    question = [a, b]
                    let showRepeatedQuestion = randomBoolWithOdds(odds: askedQuestions.count)
                    let randomQuestion = askedQuestions.randomElement()
                    if showRepeatedQuestion == true && askedQuestions.count > 1 && (randomQuestion?[0] ?? 0) != 0 { // show repeated question
                        isRepeatedQuestion = true
                        a = randomQuestion?[0] ?? 0
                        b = randomQuestion?[1] ?? 0
                        break
                    }
                } while askedQuestions.contains(question) // possible questions != 99 * 10 = 990 // it's 286-99=187 that return a whole number
                
                answer = a / b
                questionText = "\(a) ÷ \(b)"
            } while a % b != 0
            
            isRightCorrect = Bool.random()
            if isRightCorrect == true {
                rightText = "\(answer)"
                repeat {
                    leftText = "\(answer + Int.random(in: -10...10))"
                } while leftText == rightText || Int(leftText) ?? 0 < 2
            } else {
                leftText = "\(answer)"
                repeat {
                    rightText = "\(answer + Int.random(in: -10...10))"
                } while leftText == rightText || Int(rightText) ?? 0 < 2
            }
        }
        
        // saves the question for the question type
        askedQuestions.append([a, b])
        self.defaults.set(askedQuestions, forKey: "askedQuestions\(self.currentLevel ?? 0)")
        self.defaults.synchronize()
        
        levelView.updateText(titleText: questionText, leftText: leftText, rightText: rightText, isRepeatedQuestion: isRepeatedQuestion)
    }
    
    // called when tapping an answer button
    @objc func answerTapped(buttonSelected: Int) {
        if buttonSelected == 1 { // if left button was tapped
            if isRightCorrect == true {
                incorrectTapped(isRight: false)
            } else {
                correctTapped(isRight: false)
            }
        } else if buttonSelected == 2 { // if right button was tapped
            if isRightCorrect == true {
                correctTapped(isRight: true)
            } else {
                incorrectTapped(isRight: true)
            }
        }
    }
    
    // called when getting a question right
    @objc func correctTapped(isRight: Bool) {
        currentScore += 1
        createQuestion()
        levelView.correctAnimation(isRight: isRight, score: currentScore, isCoinsOn: isCoinsOn)
        if self.isHapticsOn == true {
            DispatchQueue.main.async {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            }
        }
    }
    
    // called when getting a question wrong
    @objc func incorrectTapped(isRight: Bool) {
        createQuestion()
        wrongAnswerCount += 1
        levelView.incorrectAnimation(isRight: isRight)
        if self.isHapticsOn == true {
            DispatchQueue.main.async {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        }
    }
    
    // fires the timer every second (if not paused) which decreases time left and ends the game if reached 0
    @objc func fireTimer() {
        if totalTimer.isValid && isPaused == false {
            totalTime -= 1
            levelView.reduceTime(newTime: totalTime)
            if totalTime == 0 {
                endGame()
            }
        }
    }
    
    // the level is over because the time ran out (stops timer, motion, speech input and presents the game over screen)
    @objc func endGame() {
        totalTimer.invalidate()
        if self.isSpeechOn == true {
            audioEngine.stop()
        }
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        levelView.motionManager.stopDeviceMotionUpdates()
        levelView.motionManager.stopAccelerometerUpdates()
        motionManager.stopAccelerometerUpdates()
        self.captureSession?.stopRunning()
        
        let askedQuestions = self.defaults.array(forKey: "askedQuestions\(self.currentLevel ?? 0)") as? [[Int]] ?? [[0,0]]
        self.firebaseDatabase.updateUser(askedQuestionsCurrent: askedQuestions, location: (self.currentLevel ?? 1)-1) { isSuccess in
            if isSuccess {
                print("success saved asked")
            } else {
                print("failed to save asked")
            }
        }
        
        let GameOverViewController = GameOverViewController()
        GameOverViewController.currentLevel = currentLevel
        GameOverViewController.currentDifficulty = difficulty
        GameOverViewController.score = currentScore
        GameOverViewController.wrongAnswerCount = wrongAnswerCount
        GameOverViewController.modalPresentationStyle = .overFullScreen
        present(GameOverViewController, animated: true)
    }
    
    // when completing a button press
    @objc func buttonUp(_ sender: UIButton) {
        levelView.buttonExit(sender)
        
        if sender.tag == 1 { // if left button was tapped
            answerTapped(buttonSelected: sender.tag)
        } else if sender.tag == 2 { // if right button was tapped
            answerTapped(buttonSelected: sender.tag)
        }
        
    }
    
    // when canceling a button press
    @objc func buttonExit(_ sender: UIButton) {
        levelView.buttonExit(sender)
    }
    
    // when pressing a button
    @objc func buttonDown(_ sender: UIButton) {
        if self.isHapticsOn == false {
            let impact = UISelectionFeedbackGenerator()
            impact.selectionChanged()
        }
        levelView.buttonDown(sender)
    }
    
    // restart the background animation when entering the app again
    @objc func didEnterForeground(_ notification: Notification) {
        levelView.backgroundAnimation(currentLevel: currentLevel ?? 0)
    }
    
    // sets the status bar colour
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}
