//
//  FirstLaunchViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 04.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class FirstLaunchViewController: ThemedViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var editInstructionLabel: UILabel!
    @IBOutlet weak var editInstructionIcon: UILabel!
    @IBOutlet weak var settingsInstructionIcon: UILabel!
    @IBOutlet weak var settingsInstructionLabel: UILabel!
    @IBOutlet weak var historyInstructionIcon: UILabel!
    @IBOutlet weak var historyInstructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        continueButton.tintColor = UIColor.white
        continueButton.backgroundColor = Theme.currentTheme.accent
        continueButton.layer.cornerRadius = 10
        
        editInstructionIcon.text = String.fontAwesomeIcon(name: .pencilSquare) + " "
        editInstructionIcon.font = UIFont.fontAwesome(ofSize: 36)
        editInstructionLabel.text = "Adjust the durations to your preferences."
        editInstructionLabel.numberOfLines = 0
        
        settingsInstructionIcon.text = String.fontAwesomeIcon(name: .cog) + " "
        settingsInstructionIcon.font = UIFont.fontAwesome(ofSize: 36)
        settingsInstructionLabel.text = "Customize the experience further in the Settings."
        settingsInstructionLabel.numberOfLines = 0
        
        historyInstructionIcon.text = String.fontAwesomeIcon(name: .history) + " "
        historyInstructionIcon.font = UIFont.fontAwesome(ofSize: 36)
        historyInstructionLabel.text = "See how much you have meditated in the past."
        historyInstructionLabel.numberOfLines = 0
        
        for label in themedLabels {
            label.sizeToFit()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.set(true, forKey: DefaultsKeys.hasLaunchedApp)
    }

}
