//
//  ViewController.swift
//  radiofonico
//
//  Created by Layne Johnson on 5/14/21.
//

import UIKit

class ViewController: UIViewController {

    let audioPlayer = AudioPlayer()
    let italianRadio = ItalianRadioModel()
    
    // Italian radio functions must be called with italianRadio.setSongLabel

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
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

