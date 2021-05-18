//
//  AudioPlayer.swift
//  radiofonico
//
//  Created by Layne Johnson on 5/14/21.
//

import Foundation
import AVFoundation

class AudioPlayer {

var audioPlayer: AVAudioPlayer?

func playSound(_ soundName: String) {

   let path = Bundle.main.path(forResource: soundName, ofType:nil)!

   let url = URL(fileURLWithPath: path)

   do {
       // Create the audio player
       audioPlayer = try AVAudioPlayer(contentsOf: url)
       // Play the sound effect
       audioPlayer?.play()
   } catch {
       print("Could not summon audio player")
   }
}

}
