//
//  MeditationViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

// TODO: Support for open end sessions

import UIKit

class MeditationViewController: UIViewController {
    
    var remainingTime: TimeInterval!
    var timeMeditated: TimeInterval = 0
    
    var timer = Timer()
    

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Check if remainingTime was set properly, otherwise abort

        // Set up and start the timer
        startTimer()
        updateLabel()
        
        // Play starting gong
        // TODO: Read gong sound settings from UserDefaults
        // AudioHelper.shared.configureAudioPlayer(with: ...)
        AudioHelper.shared.play()
        
        // Disable system idle timer
        UIApplication.shared.isIdleTimerDisabled = true
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
        remainingTime! -= 1.0
        timeMeditated += 1.0
        updateLabel()
        
        if remainingTime == 2.0 {
            // Prepare gong sound ahead of time
            AudioHelper.shared.sound?.prepareToPlay()
        }
        
        if remainingTime <= 0.0 {
            // Play gong and segue to end screen
            AudioHelper.shared.play()
            performSegue(withIdentifier: PropertyKeys.endMeditationSegue, sender: self)
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
        // Re-enable system idle timer
        UIApplication.shared.isIdleTimerDisabled = false
        guard let identifier = segue.identifier else { return }
        if identifier == PropertyKeys.endMeditationSegue, let destination = segue.destination as? FinishViewController {
            destination.finalTimeMeditated = timeMeditated
        }
    }

}
