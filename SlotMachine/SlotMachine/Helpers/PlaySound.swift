//
//  PlaySound.swift
//  SlotMachine
//
//  Created by Sunil Maurya on 04/01/24.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR: Couldn't find file to play sound")
        }
    }
}
