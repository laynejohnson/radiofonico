//
//  ItalianRadioModel.swift
//  radiofonico
//
//  Created by Layne Johnson on 5/14/21.
//

import Foundation
import UIKit
import AVFoundation

var audioPlayer: AVAudioPlayer?

class ItalianRadioModel {
    
    @IBOutlet weak var songLabel: UILabel!
    
    
    let italianRadioSongs = ["Lucio Dalla - Washington.mp3", "Mango - Bella d'Estate.mp3", "Franco Battiato - Summer On A Solitary Beach.mp3" ]
    
    let defaultSongLabel = "Press play to vibe"
    
    var song = ""

    var isPlaying = false
    
    func chooseSong() -> String {
        song = italianRadioSongs.randomElement()!
        return song
    }
    
    func setSongLabel(song: String) {
        
        // Modify song name string for display
        let modifiedSong = song.replacingOccurrences(of: ".mp3", with: "", options: [.caseInsensitive, .regularExpression])
        
        songLabel.text = modifiedSong
    }
    
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
    
    func playPreviousSong() {
        
        if isPlaying == true {
            
            // Get index of current song
            print("Current song: \(song)")
            let songIndex = italianRadioSongs.firstIndex(of: "\(song)")
            print("Song index: \(songIndex!)")
            
            // Get index of previous song
            var previousSongIndex = songIndex! - 1
            print("previous song index: \(previousSongIndex)")
            
            // Reset index at end of array
            if previousSongIndex > italianRadioSongs.count - 1 || previousSongIndex < 0 {
                
                previousSongIndex = italianRadioSongs.endIndex - 1
                let previousSong = italianRadioSongs[previousSongIndex]
                song = previousSong
                playSound(song)
                setSongLabel(song: song)
            } else {
                
                // Play previous song
                let previousSong = italianRadioSongs[previousSongIndex]
                print("previous song: \(previousSong)")
                song = previousSong
                print("New Current Song: \(song)")
                playSound(song)
                
                // Set song label for next song
                setSongLabel(song: previousSong)
            }
        } else {
            
            // Add animation to "Press play to vibe"
            print(defaultSongLabel)
        }
    }
    
    func radioOnOff(sender: UIButton) {

        // Toggle radio state
        sender.isSelected.toggle()

        if sender.isSelected == true {
            isPlaying = true
            song = italianRadioSongs[0]
            setSongLabel(song: song)
            playSound(song)
        } else if sender.isSelected == false {
            isPlaying = false
           audioPlayer?.pause()
            setSongLabel(song: defaultSongLabel)
        }
    }
    
    func playNextSong() {
        
        if isPlaying == true {
            // Get index of current song
            print("Current song: \(song)")
            let songIndex = italianRadioSongs.firstIndex(of: "\(song)")
            print("Song index: \(songIndex!)")
            
            // Get index of next song
            var nextSongIndex = songIndex! + 1
            print("Next song index: \(nextSongIndex)")
            
            // Reset index at end of array
            if nextSongIndex > italianRadioSongs.count - 1 {
                nextSongIndex = 0
                let nextSong = italianRadioSongs[nextSongIndex]
                song = nextSong
                playSound(song)
                setSongLabel(song: song)
            } else {
                // Play next song
                let nextSong = italianRadioSongs[nextSongIndex]
                print("Next song: \(nextSong)")
                song = nextSong
                print("New Current Song: \(song)")
                playSound(song)
                
                // Set song label for next song
                // TODO: Refactor; add setSongLabel label function to playSound function
                setSongLabel(song: nextSong)
            }
        } else {
            // Add animation to "Press play to vibe"
            print(defaultSongLabel)
        }
    }
    
}
