//
//  ViewController.swift
//  radiofonico
//
//  Created by Layne Johnson on 5/14/21.
//

import UIKit
import AVFoundation

// MARK: - Development TODOs:

// TODO: Add song timer
// TODO: Refactor play/pause to pause/play current song. Do not reset to [0].

class ViewController: UIViewController {
    
    
    @IBOutlet weak var songLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?
    let italianRadio = ItalianRadioModel()
    
    let defaultSongLabel = " "
    let defaultArtistLabel = "Press play to vibe ✨"
    
    let radioPink = #colorLiteral(red: 0.9166277051, green: 0.4749821424, blue: 0.5771788955, alpha: 1)
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        songLabel.text = defaultSongLabel
        artistLabel.text = defaultArtistLabel
        
    }
    
    // IBAction Functions
    
    @IBAction func playPreviousSong(_ sender: UIButton) {
        
        if italianRadio.isPlaying == false {
            artistLabel.text = defaultArtistLabel
            artistLabel.backgroundColor = radioPink
            
        } else {
            let song = italianRadio.playPreviousSong()
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
        }
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

