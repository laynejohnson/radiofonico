//
//  ViewController.swift
//  radiofonico
//
//  Created by Layne Johnson on 5/14/21.
//

// italian radio functions should return song and pass to view controller
//view controller sets song label

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var songLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?
    let italianRadio = ItalianRadioModel()
    let defaultSongLabel = "Press play to vibe..."
    let defaultArtistLabel = "✨"
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        songLabel.text = defaultSongLabel
        artistLabel.text = defaultArtistLabel
        
    }
    
    // IBAction Functions
    
    @IBAction func playPreviousSong(_ sender: UIButton) {
        
        let song = italianRadio.playPreviousSong()
        italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
    }
    
    @IBAction func playPauseRadio(_ sender: UIButton) {
        
        let song = italianRadio.radioOnOff(sender: sender)
        italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
        
    }
    
    @IBAction func playNextSong(_ sender: UIButton) {
        
        let song = italianRadio.playNextSong()
        italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
    }
    
}

