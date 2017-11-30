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
    var timeMeditated: TimeInterval = 0
    var previousBrightness = CGFloat(0.5)
    
    var timer = Timer()
    var isOpenEnd = false

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if remainingTime was set properly, otherwise abort
        guard remainingTime != nil else {
            navigationController?.popViewController(animated: true)
            return
        }

        // Set up and start the timer
        startTimer()
        updateLabel()
        
        // Play starting gong
        // AudioHelper.shared.configureAudioPlayer(with: ...)
        let startGong = userDefaults.integer(forKey: DefaultsKeys.startGong)
        if startGong != 0 {
            AudioHelper.shared.stop()
            AudioHelper.shared.play(startGong)
        }
        
        // Disable system idle timer
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Screen brightness
        if userDefaults.bool(forKey: DefaultsKeys.changedBrightness) {
            previousBrightness = UIScreen.main.brightness
            if previousBrightness > 0.1 {
                UIScreen.main.setBrightness(0.1, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(self.timerTick), userInfo: nil, repeats: true)
    }
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func timerTick() {
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
    
    func updateLabel() {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        let formattedDuration = formatter.string(from: remainingTime)
        durationLabel.text = (remainingTime < 10*60 ? "0" : "") + (formattedDuration ?? "?:??")
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        if timer.isValid {
            // Pause the timer
            stopTimer()
            pauseButton.setTitle("Continue", for: .normal)
        } else {
            // Continue the timer
            startTimer()
            pauseButton.setTitle("Pause", for: .normal)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Stop timer before anything else
        stopTimer()
        // Play gong
        let endGong = userDefaults.integer(forKey: DefaultsKeys.endGong)
        if endGong != 0 {
            AudioHelper.shared.stop()
            AudioHelper.shared.play(endGong)
        }
        // Re-enable system idle timer
        UIApplication.shared.isIdleTimerDisabled = false
        // Readjust screen brightness
        if userDefaults.bool(forKey: DefaultsKeys.changedBrightness) {
            UIScreen.main.setBrightness(previousBrightness, animated: true)
        }
        // Actual preparation for segue
        guard let identifier = segue.identifier else { return }
        if identifier == PropertyKeys.endMeditationSegue, let destination = segue.destination as? FinishViewController {
            destination.finalTimeMeditated = timeMeditated
        }
    }

}
