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
    
    override var owlImageVariant: ImageVariant { return .open_yay }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // restore view alpha
        UIView.animate(withDuration: 3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.view.alpha = 1.0
        }, completion: nil)

        // Set the label
        if let finalTimeMeditated = finalTimeMeditated {
            let minutes = Int(finalTimeMeditated/60)
            let seconds = Int(finalTimeMeditated)%60
            let minutePad = minutes == 1 ? "" : "s"
            let secondPad = seconds == 1 ? "" : "s"
            var text = "Meditated for"
            text += minutes > 0 ? " \(minutes) minute\(minutePad)" : ""
            text += minutes > 0 && seconds > 0 ? " and" : ""
            text += seconds > 0 || minutes == 0 ? " \(seconds) second\(secondPad)" : ""
            text += "."
            finalTimeLabel.text = text
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func goBackButtonTapped(_ sender: UIButton) {
        // Prepare transition animation
        let transition = CATransition.init()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        // Push view controller
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popToRootViewController(animated: false)
    }
    
}
