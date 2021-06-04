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
// TODO: Add stars and scale animation for press play to vibe
// TODO: Change button color when pressing previous/next buttons

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    // ---------------------------------- //
    // - - - - - - -  OUTLETS - - - - - - //
    // ---------------------------------- //

    @IBOutlet weak var songLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var pinkItaly: UIImageView!
    
    
    // MARK: - Variables
    // ---------------------------------- //
    // - - - - - - -  VARS - - - - - - -  //
    // ---------------------------------- //

    var audioPlayer: AVAudioPlayer?
    let italianRadio = ItalianRadioModel()
    
    let defaultSongLabel = " "
    let defaultArtistLabel = "Press play to vibe. . ."
    
    let radioPink = #colorLiteral(red: 0.9166277051, green: 0.4749821424, blue: 0.5771788955, alpha: 1)
    let radioSquid = #colorLiteral(red: 0.2235294118, green: 0.2274509804, blue: 0.1960784314, alpha: 1)
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        songLabel.text = defaultSongLabel
        artistLabel.text = defaultArtistLabel
    
        
    }
    
    //MARK: - Functions
    
    func animatedImages(for name: String) -> [UIImage] {
        
        var i = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(i)") {
            images.append(image)
            i += 1
        }
        
        return images
    }
    
    func animatedImagesReverse(for name: String) -> [UIImage] {
        
        var i = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(i)") {
            images.append(image)
            i -= 1
        }
        
        return images
    }
    
    // MARK: - IBOutlets
    // ---------------------------------- //
    // - - - - - - - ACTIONS - - - - - - - //
    // ---------------------------------- //
    
    @IBAction func playPreviousSong(_ sender: UIButton) {
        
        if italianRadio.isPlaying == false {
            songLabel.text = " "
            artistLabel.text = defaultArtistLabel
            
            // Text animation
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.artistLabel.transform = .init(scaleX: 1.25, y: 1.25)
                self.artistLabel.textColor = self.radioPink
            }) { (finished: Bool) -> Void in
                self.artistLabel.textColor = self.radioSquid
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    self.artistLabel.transform = .identity
                })
            }
            
        } else {
            let song = italianRadio.playPreviousSong()
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
        }
    }
    
    @IBAction func playPauseRadio(_ sender: UIButton) {
        
        let song = italianRadio.radioOnOff(sender: sender)
        italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
        
        // Start animation on play
        pinkItaly.animationImages = animatedImages(for: "radiofonico")
        pinkItaly.animationDuration = 13
        pinkItaly.animationRepeatCount = 0
        pinkItaly.image = pinkItaly.animationImages?.first
        pinkItaly.startAnimating()
        
        // Stop animation on pause
        if italianRadio.isPlaying == false {
            pinkItaly.stopAnimating()
        }
        
    }
    
    @IBAction func playNextSong(_ sender: UIButton) {
        
        if italianRadio.isPlaying == false {
            songLabel.text = " "
            artistLabel.text = defaultArtistLabel
            
            // Text animation
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.artistLabel.transform = .init(scaleX: 1.25, y: 1.25)
                self.artistLabel.textColor = self.radioPink
            }) { (finished: Bool) -> Void in
                self.artistLabel.textColor = self.radioSquid
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    self.artistLabel.transform = .identity
                })
            }
            
        } else {
            
            let song = italianRadio.playNextSong()
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
        }
    }

    
} // End ViewController Class

