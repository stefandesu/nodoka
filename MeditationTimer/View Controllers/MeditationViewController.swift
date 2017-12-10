//
//  MeditationViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class MeditationViewController: ThemedViewController {
    
    let userDefaults = UserDefaults.standard
    
    var remainingTime: TimeInterval!
    var preparationTime: TimeInterval!
    var timeMeditated: TimeInterval = 0
    var previousBrightness = CGFloat(0.5)
    var timeUntilInfoFade: TimeInterval = 0.0
    
    var timer = Timer()
    var isOpenEnd = false
    var isPausedByBackground = false
    var isPausedByButton = false
    
    @IBOutlet weak var pausedLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    let pauseAttributedTitle = FontHelper.generate(icon: String.fontAwesomeIcon(name: .pause), withText: "", ofSize: 48, andTextColor: Theme.currentTheme.accent)
    let continueAttributedTitle = FontHelper.generate(icon: String.fontAwesomeIcon(name: .play), withText: "", ofSize: 48, andTextColor: Theme.currentTheme.accent)
    
    override var owlImageVariant: ImageVariant { return preparationTime > 0 || !timer.isValid ? .half : .closed }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if remainingTime was set properly, otherwise abort
        guard remainingTime != nil, preparationTime != nil else {
            prepareTransition()
            navigationController?.popViewController(animated: false)
            return
        }

        // Set up
        updateLabel()
        infoLabel.text = ""
        
        postLeaveRoutine()
        addNotificationOberserver()
        startingSound()
        
        // Set up button titles
        pauseButton.setAttributedTitle(pauseAttributedTitle, for: .normal)
        stopButton.setAttributedTitle(FontHelper.generate(icon: "", withText: "Stop", ofSize: 15, andTextColor: Theme.currentTheme.accent), for: .normal)
    }
    
    @objc func appDidEnterBackground() {
        print("appDidEnterBackground")
        if timer.isValid {
            isPausedByBackground = true
        }
        preLeaveRoutine()
    }
    @objc func appDidBecomeActive() {
        print("appDidBecomeActive")
        // Save new screen brightness in case user changed it during background
        previousBrightness = UIScreen.main.brightness
        
        if isPausedByBackground {
            postLeaveRoutine()
            infoLabel.text = "The timer only works when the application is active."
            timeUntilInfoFade = 5.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(self.timerTick), userInfo: nil, repeats: true)
            isPausedByBackground = false
            isPausedByButton = false
        }
        pausedLabel?.text = ""
    }
    func stopTimer() {
        timer.invalidate()
        pausedLabel?.text = "Paused"
    }
    
    fileprivate func startingSound() {
        if preparationTime == 0 {
            // Play starting gong
            let startGong = userDefaults.integer(forKey: DefaultsKeys.startGong)
            if startGong != 0 {
                AudioHelper.shared.stop()
                AudioHelper.shared.play(startGong)
            }
            // Change owl image
            setUpTheme()
        }
    }
    
    @objc func timerTick() {
        print("Timer Tick (\(preparationTime), \(remainingTime), \(timeMeditated))")
        
        // Fade info label after a while
        if timeUntilInfoFade >= 1 {
            timeUntilInfoFade -= 1.0
            if timeUntilInfoFade == 0.0 {
                UIView.animate(withDuration: 1.0, animations: {
                    self.infoLabel.alpha = 0.0
                }, completion: { (_) in
                    self.infoLabel.text = ""
                    self.infoLabel.alpha = 1.0
                })
            }
        }
        
        if preparationTime > 0 {
            // Preparing
            preparationTime = preparationTime - 1.0
            startingSound()
            updateLabel()
        } else {
            // Meditating
            timeMeditated += 1.0
            if isOpenEnd {
                remainingTime! += 1.0
                updateLabel()
            } else {
                remainingTime! -= 1.0
                updateLabel()
                
                if remainingTime <= 0.0 {
                    // Segue to end screen
                    // performSegue(withIdentifier: PropertyKeys.endMeditationSegue, sender: self)
                    stop()
                }
            }
        }
    }
    
    func updateLabel() {
        if preparationTime > 0 {
            durationLabel.text = "\(Int(preparationTime!))"
        } else {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = [.pad]
            let formattedDuration = formatter.string(from: remainingTime)
            durationLabel.text = (remainingTime < 10*60 ? "0" : "") + (formattedDuration ?? "?:??")
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        if timer.isValid {
            // Pause the timer
            preLeaveRoutine()
            pauseButton.setAttributedTitle(continueAttributedTitle, for: .normal)
            isPausedByButton = true
        } else {
            // Continue the timer
            postLeaveRoutine()
            pauseButton.setAttributedTitle(pauseAttributedTitle, for: .normal)
        }
        setUpTheme()
    }

    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == PropertyKeys.endMeditationSegue && timeMeditated > 0.0  {
            return true
        } else {
            preLeaveRoutine()
            removeNoficationObserver()
            // Go back to main screen
            navigationController?.popViewController(animated: true)
            return false
        }
    }
    
    func preLeaveRoutine() {
        print("preLeaveRoutine")
        // Stop timer
        stopTimer()
        // Re-enable system idle timer
        UIApplication.shared.isIdleTimerDisabled = false
        // Readjust screen brightness
        if userDefaults.bool(forKey: DefaultsKeys.changedBrightness) {
            UIScreen.main.setBrightness(previousBrightness, animated: true)
        }
    }
    
    func postLeaveRoutine() {
        print("postLeaveRoutine")
        
        // Start timer
        startTimer()
        
        // Disable system idle timer
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Save screen brightness and dim
        if userDefaults.bool(forKey: DefaultsKeys.changedBrightness) {
            previousBrightness = UIScreen.main.brightness
            if previousBrightness > 0.1 {
                UIScreen.main.setBrightness(0.1, animated: true)
            }
        }
    }
    
    func removeNoficationObserver() {
        // Remove notification observers
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    func addNotificationOberserver() {
        // Set up enter background and became active notifications
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        preLeaveRoutine()
        
        removeNoficationObserver()
        
        // Play gong
        let endGong = userDefaults.integer(forKey: DefaultsKeys.endGong)
        if endGong != 0 {
            AudioHelper.shared.stop()
            AudioHelper.shared.play(endGong)
        }
        // Actual preparation for segue
        guard let identifier = segue.identifier else { return }
        if identifier == PropertyKeys.endMeditationSegue, let destination = segue.destination as? FinishViewController {
            destination.finalTimeMeditated = timeMeditated
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        stop()
    }
    
    func stop() {
        preLeaveRoutine()
        removeNoficationObserver()
        guard timeMeditated > 0.0 else {
            // Go back to main screen
            prepareTransition()
            navigationController?.popViewController(animated: false)
            return
        }
        if let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PropertyKeys.finishedStoryboard) as? FinishViewController {
            // Play gong
            let endGong = userDefaults.integer(forKey: DefaultsKeys.endGong)
            if endGong != 0 {
                AudioHelper.shared.stop()
                AudioHelper.shared.play(endGong)
            }
            // Prepare destination view controller
            destination.finalTimeMeditated = timeMeditated
            // Prepare transition animation
            prepareTransition()
            navigationController?.pushViewController(destination, animated: false)
        }
    }
    
    func prepareTransition() {
        // Prepare transition animation
        let transition = CATransition.init()
        transition.duration = 0.5
        transition.type = kCATransitionFade
        // Push view controller
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
    

}
