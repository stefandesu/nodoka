//
//  FinishViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class FinishViewController: ThemedViewController {

    let userDefaults = UserDefaults.standard
    @IBOutlet weak var finalTimeLabel: UILabel!
    
    var finalTimeMeditated: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // restore view alpha
        UIView.animate(withDuration: 3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.alpha = 1.0
        }, completion: nil)

        // Set the label
        if let finalTimeMeditated = finalTimeMeditated {
            let minutes = Int(finalTimeMeditated/60)
            let seconds = Int(finalTimeMeditated)%60
            let minutePad = minutes == 1 ? "" : "s"
            let secondPad = seconds == 1 ? "" : "s"
            finalTimeLabel.text = "Meditated for \(minutes) minute\(minutePad) and \(seconds) second\(secondPad)."
            // Create MeditationSession object and save to disk
            let session = MeditationSession(date: Date(), duration: finalTimeMeditated)
            session.save()
            // Write to Apple Health
            if userDefaults.bool(forKey: DefaultsKeys.healthKitEnabled) {
                HealthKitHelper.healthQueue.async {
                    HealthKitHelper.shared.writeMindfulnessData(delegate: nil, session: session)
                }
            }
        } else {
            finalTimeLabel.text = "Something went wrong."
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
