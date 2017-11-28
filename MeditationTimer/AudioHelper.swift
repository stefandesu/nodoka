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
    
    var sound: AVAudioPlayer?
    
    static func setAudioSession(to status: Bool) {
        // make sure sound plays even on mute
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(status)
                print("AVAudioSession is Active")
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
        configureAudioPlayer(with: 1)
    }
    
    func play() {
        AudioHelper.setAudioSession(to: true)
        sound?.play()
    }
    
    func configureAudioPlayer(with bellNumber: Int) {
        // Set up gong sound
        var filename = "bell"
        if bellNumber < 10 {
            filename += "00"
        } else if bellNumber < 100 {
            filename += "0"
        }
        filename += "\(bellNumber).mp3"
        if let path = Bundle.main.path(forResource: filename, ofType:nil) {
            let url = URL(fileURLWithPath: path)
            sound = try? AVAudioPlayer(contentsOf: url)
            sound?.delegate = self
            sound?.volume = 0.3
        }
    }

}
