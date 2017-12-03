//
//  SetSound2TableViewCell.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 03.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SetSound2TableViewCell: UITableViewCell {

    var delegate: SetSoundTableViewCellDelegate?
    @IBOutlet weak var soundVolumeSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        soundVolumeSlider.tintColor = Theme.currentTheme.accent
        soundVolumeSlider.isContinuous = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func soundVolumeSliderChanged(_ sender: UISlider) {
        delegate?.defaultSoundVolumeChanged(to: sender.value)
    }
    
}
