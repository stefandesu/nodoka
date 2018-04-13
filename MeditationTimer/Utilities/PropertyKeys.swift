//
//  PropertyKeys.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import Foundation

struct PropertyKeys {
    static let startMeditationSegue = "startMeditation"
    static let endMeditationSegue = "endMeditation"
    static let openSettingsSegue = "openSettings"
    static let editDurationsSegue = "editDurations"
    static let settingsGongStartSegue = "settingsGongStart"
    static let settingsGongEndSegue = "settingsGongEnd"
    static let settingsGongIntervalSegue = "settingsGongInterval"
    static let settingsGongCellIdentifier = "settingsGongCell"
    static let settingsThemeSegue = "settingsTheme"
    static let settingsThemeCellIdentifier = "settingsThemeCell"
    static let debugListCell = "debugListCell"
    static let settingsDurationSegue = "settingsDuration"
    static let preparationPickerTag = 0
    static let meditationPickerTag = 1
    static let intervalPickerTag = 2
    static let setSound1TableViewCellIdentifier = "setSound1TableViewCell"
    static let setSound2TableViewCellIdentifier = "setSound2TableViewCell"
    // Storyboards
    static let firstLaunchStoryboard = "FirstLaunchStoryboard"
    static let defaultStoryboard = "DefaultStoryboard"
    static let startStoryboard = "startStoryboard"
    static let meditationStoryboard = "meditationStoryboard"
    static let finishedStoryboard = "finishedStoryboard"
}
