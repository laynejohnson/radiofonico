//
//  ViewController.swift
//  radiofonico
//
//  Created by Layne Johnson on 5/14/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    

    var audioPlayer: AVAudioPlayer?
    let italianRadio = ItalianRadioModel()
    let defaultSongLabel = "Press play to vibe 🤙"
    
// MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        italianRadio.setSongLabel(song: defaultSongLabel)
        
    }
    
// IBAction Functions
    
    @IBAction func playPreviousSong(_ sender: UIButton) {
        
        italianRadio.playPreviousSong()
    }
    
    @IBAction func playPauseRadio(_ sender: UIButton) {
        
        italianRadio.radioOnOff(sender: sender)
    }
    
    @IBAction func playNextSong(_ sender: UIButton) {
        
        italianRadio.playNextSong()
    }

}

