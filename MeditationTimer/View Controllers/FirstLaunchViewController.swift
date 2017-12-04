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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        continueButton.tintColor = UIColor.white
        continueButton.backgroundColor = Theme.currentTheme.accent
        continueButton.layer.cornerRadius = 10
        
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
