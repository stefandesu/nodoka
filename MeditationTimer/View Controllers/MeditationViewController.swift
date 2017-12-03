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
    
    var timer = Timer()
    var isOpenEnd = false
    var isPausedByBackground = false
    var isPausedByButton = false

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if remainingTime was set properly, otherwise abort
        guard remainingTime != nil, preparationTime != nil else {
            navigationController?.popViewController(animated: true)
            return
        }

        // Set up
        updateLabel()
        infoLabel.text = ""
        
        postLeaveRoutine()
        addNotificationOberserver()
        startingSound()
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
    }
    func stopTimer() {
        timer.invalidate()
    }
    
    fileprivate func startingSound() {
        if preparationTime == 0 {
            // Play starting gong
            let startGong = userDefaults.integer(forKey: DefaultsKeys.startGong)
            if startGong != 0 {
                AudioHelper.shared.stop()
                AudioHelper.shared.play(startGong)
            }
        }
    }
    
    @objc func timerTick() {
        print("Timer Tick (\(preparationTime), \(remainingTime), \(timeMeditated))")
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
                    performSegue(withIdentifier: PropertyKeys.endMeditationSegue, sender: self)
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
            pauseButton.setTitle("Continue", for: .normal)
            isPausedByButton = true
        } else {
            // Continue the timer
            postLeaveRoutine()
            pauseButton.setTitle("Pause", for: .normal)
        }
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

}
