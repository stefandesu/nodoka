//
//  FinishViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class FinishViewController: ThemedViewController {

    @IBOutlet weak var finalTimeLabel: UILabel!
    
    var finalTimeMeditated: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the label
        if let finalTimeMeditated = finalTimeMeditated {
            let minutes = Int(finalTimeMeditated/60)
            let seconds = Int(finalTimeMeditated)%60
            let minutePad = minutes == 1 ? "" : "s"
            let secondPad = seconds == 1 ? "" : "s"
            finalTimeLabel.text = "Meditated for \(minutes) minute\(minutePad) and \(seconds) second\(secondPad)."
        } else {
            finalTimeLabel.text = "Something went wrong."
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
