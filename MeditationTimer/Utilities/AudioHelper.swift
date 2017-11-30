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
    
    var sounds: [Int: AVAudioPlayer?] = [:]
    
    
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
        AudioHelper.setAudioSession(to: true)
        sounds[bellNumber]??.play()
    }
    func stop() {
        AudioHelper.setAudioSession(to: false)
        for sound in AudioHelper.availableSounds {
            sounds[sound]??.stop()
            sounds[sound]??.currentTime = 0
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
            sounds[bellNumber]??.volume = 0.3
            sounds[bellNumber]??.prepareToPlay()
        }
    }

}
