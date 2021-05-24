//
//  ViewController.swift
//  radiofonico
//
//  Created by Layne Johnson on 5/14/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
   // MARK: IBOutlets
    
    @IBOutlet weak var songLabel: UILabel!
    
    // MARK: Initializers
    
//    var audioPlayer = AVAudioPlayer()
    var audioPlayer: AVAudioPlayer?
    let italianRadio = ItalianRadioModel()
    
// MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    
    
    @IBAction func playPreviousSong(_ sender: UIButton) {
        
        let song = italianRadio.playPreviousSong()
        italianRadio.setSongLabel(song: song, label: songLabel)
    }
    
    @IBAction func playPauseRadio(_ sender: UIButton) {
        
        italianRadio.radioOnOff(sender: sender)
    }
    
    @IBAction func playNextSong(_ sender: UIButton) {
        
        italianRadio.playNextSong()
    }
    
    
    

}

