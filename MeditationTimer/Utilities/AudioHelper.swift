//
//  AudioHelper.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit
import AVFoundation

class AudioHelper: NSObject, AVAudioPlayerDelegate {
    
    static let shared = AudioHelper()
    static let availableSounds = [1]
    static let audioQueue = DispatchQueue(label: "audioQueue", attributes: .concurrent)
    
    var sounds: [Int: AVAudioPlayer?] = [:]
    let userDefaults = UserDefaults.standard
    
    static func setAudioSession(to status: Bool) {
        // make sure sound plays even on mute
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            do {
                try AVAudioSession.sharedInstance().setActive(status)
            } catch _ as NSError {
                // print(error.localizedDescription)
            }
        } catch _ as NSError {
            // print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        AudioHelper.setAudioSession(to: false)
    }
    
    override init() {
        super.init()
        for sound in AudioHelper.availableSounds {
            configureAudioPlayer(with: sound)
        }
    }
    func play(_ bellNumber: Int) {
        // Set sound volume
        if userDefaults.bool(forKey: DefaultsKeys.useSystemSound) {
            sounds[bellNumber]??.volume = 0.3
        } else {
            print(AVAudioSession.sharedInstance().outputVolume)
            // TODO: Adjust formula
            let volume = 0.4 * (userDefaults.float(forKey: DefaultsKeys.soundVolume) / AVAudioSession.sharedInstance().outputVolume)
            sounds[bellNumber]??.volume = volume
            print(volume)
        }
        // Play async in separate queue
        AudioHelper.audioQueue.async {
            AudioHelper.setAudioSession(to: true)
            self.sounds[bellNumber]??.play()
        }
    }
    
    func stop() {
        AudioHelper.audioQueue.async {
            for sound in AudioHelper.availableSounds {
                self.sounds[sound]??.stop()
                self.sounds[sound]??.currentTime = 0
            }
        }
    }
    
    func configureAudioPlayer(with bellNumber: Int) {
        // Set up gong sound
        var filename = "bell"
        if bellNumber < 10 {
            filename += "00"
        } else if bellNumber < 100 {
            filename += "0"
        }
        filename += "\(bellNumber)"
        if let sound = NSDataAsset(name: filename) {
            sounds[bellNumber] = try? AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
            sounds[bellNumber]??.delegate = self
            sounds[bellNumber]??.prepareToPlay()
        }
    }

}
