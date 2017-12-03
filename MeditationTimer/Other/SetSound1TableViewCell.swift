//
//  SetSound1TableViewCell.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 03.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

protocol SetSoundTableViewCellDelegate {
    func useSystemSoundSwitchChanged(to: Bool)
    func defaultSoundVolumeChanged(to: Float)
}

class SetSound1TableViewCell: UITableViewCell {

    var delegate: SetSoundTableViewCellDelegate?
    @IBOutlet weak var useSystemSoundSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        useSystemSoundSwitch.onTintColor = Theme.currentTheme.accent
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func useSystemSoundSwitchChanged(_ sender: UISwitch) {
        delegate?.useSystemSoundSwitchChanged(to: sender.isOn)
    }
    
    
}
