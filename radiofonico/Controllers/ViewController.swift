//
//  ViewController.swift
//  radiofonico
//
//  Created by Layne Johnson on 5/14/21.
//  Copyright © 2021. All rights reserved.

/*
 
 Music compilation by Beats in Space Radio:
 
 https://www.mixcloud.com/bisradio/bis-radio-show-1072-with-il-quadro-di-troisi-donato-dozzy-eva-geist/
 
 TRACKLIST: 1. Mango-Bella d’estate 2. Lucio Dalla-Washington 3. Franco Battiato-Summer on a Solitary Beach 4. Lucio Battisti-Rilassati ed Ascolta 5. Matia Bazar-Palestina-1983 Ariston6. Krisma-Samora Club7. Paolo Tofani-Un Altro Universo 8. Alice-Chan-Son Egocentrique 9. Giuni Russo-Buenos Aires10. Enrico Ruggeri-Polvere CGD11. Anna Oxa-Uragano e Nuvole 12. Garbo-A Berlino Va Bene 13. Righeira-Disco Volante 14. Gaznevada-Agente Speciale 15. Mike Francis-Survivor16. Marcella Bella-Nell’Aria 17. Teresa De Sio-Voglia E Turna
 
 */

import UIKit
import AVFoundation

// MARK: - Dev TODOs:

/*
 Features:
 // TODO: Add "Radio Fonico" to launch screen
 // TODO: Implement repeat function
 // TODO: Implement autoplay
 // TODO: Add background playback
 
 Refactor:
 // TODO: Refactor play/pause to pause/play current song. Do not reset to [0].
 // TODO: Refactor to remove song return
 // TODO: Refactor with Song class
 
 */

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // Song and album view.
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    // Progress bar.
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var songTimeLabel: UILabel!
    
    // Radio controls.
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var manoButton: UIButton!
    
    // MARK: - Variables
    
    let italianRadio = ItalianRadioModel()
    var timer: Timer?
    
    let song = " "
    let defaultSongLabel = " "
    let defaultArtistLabel = " "
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songLabel.text = ""
        artistLabel.text = ""
        
        albumArt.image = #imageLiteral(resourceName: "premi_play_v2")
        
        elapsedTimeLabel.text = "00:00"
        songTimeLabel.text = "00:00"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Hide navigation bar.
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Animations
    
    func animateButton(button: UIButton) {
        
        // Scale animation for buttons
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            button.transform = .init(scaleX: 1.25, y: 1.25)
        }) { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                button.transform = .identity
            })
        }
    }
    
    // MARK: - UI Functions
    
    // Set favorite button.
    func setMano(status: Bool) {
        
        if status == true {
            manoButton.isSelected = true
            
        } else {
            manoButton.isSelected = false
        }
    }
    
    func getFormattedTime(timeInterval: TimeInterval) -> String {
        
        let mins = timeInterval / 60
        let secs = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        
        guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return ""
        }
        return "\(minsStr):\(secsStr)"
    }
    
    @objc func updateProgressBar() {
        
        guard let audioPlayer = audioPlayer else { return }
        
        let duration = audioPlayer.duration
        
        // Set progress bar.
        progressBar.value = Float(audioPlayer.currentTime)
        
        // Set label text.
        songTimeLabel.text = getFormattedTime(timeInterval: duration)
        elapsedTimeLabel.text = getFormattedTime(timeInterval: audioPlayer.currentTime)
    }
    
    // MARK: - IBActions
    
    @IBAction func progressValueChanged(_ sender: UISlider) {
        
        if italianRadio.isPlaying == true {
            
            audioPlayer?.currentTime = Float64(progressBar.value)
        }
    }
    
    @IBAction func playPreviousSong(_ sender: UIButton) {
        
        // Animate play/pause button if no song is playing.
        if italianRadio.isPlaying == false && songLabel.text == "" {
            
            animateButton(button: playPauseButton)
            
        } else if italianRadio.isPlaying == true {
            
            // Choose song.
            let song = italianRadio.playPreviousSong()
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
            
            // Check if song is a favorite.
            let isFavorite = italianRadio.checkFavorite(song: song)
            
            // Set favorite button.
            setMano(status: isFavorite)
            
        } else {
            
            // Animate play/pause button if no song is playing.
            animateButton(button: playPauseButton)
            
        }
    }
    
    @IBAction func playPauseRadio(_ sender: UIButton) {
        
        // Choose song.
        let song = italianRadio.radioOnOff(sender: sender)
        
        if song == defaultSongLabel {
            
            // Flash play button.
            animateButton(button: playPauseButton)
            
        } else {
            
            // Set song label.
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
            
            // Check song favorite status.
            let isFavorite = italianRadio.checkFavorite(song: song)
            
            // Set favorite button.
            setMano(status: isFavorite)
        }
        
        if italianRadio.isPlaying == true {
            
            // Set album art image.
            albumArt.image = #imageLiteral(resourceName: "album_art")
            
            // Set progress bar values.
            progressBar.value = 0.0
            progressBar.maximumValue = Float(audioPlayer!.duration)
            
            // Initiate timer.
            timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func playNextSong(_ sender: UIButton) {
        
        if italianRadio.isPlaying == false && songLabel.text == "" {
            
            // Animate play/pause button if no song is playing.
            animateButton(button: playPauseButton)
            
        } else if italianRadio.isPlaying == true {
            
            // Get next song.
            let song = italianRadio.playNextSong()
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
            
            // Check favorite status.
            let isFavorite = italianRadio.checkFavorite(song: song)
            
            // Set favorite button.
            setMano(status: isFavorite)
            
        } else {
            
            // Animate play/pause button.
            animateButton(button: playPauseButton)
        }
    }
    
    @IBAction func replaySong(_ sender: UIButton) {
        
        if songLabel.text == "" {
            
            // Animate play/pause button if no song is playing.
            animateButton(button: playPauseButton)
        } else {
            
            // Toggle replay button state.
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func addFavorite(_ sender: UIButton) {
        
        if songLabel.text == "" {
            
            // Animate play button.
            animateButton(button: playPauseButton)
        }
        
        else if songLabel.text != nil && songLabel.text != defaultSongLabel && sender.isSelected == false {
            
            // Set current song as favorite.
            sender.isSelected = true
            
            // Set song label.
            let song = songLabel.text
            
            // Add favorite song to favorite songs.
            italianRadio.addFavorite(song: song!)
            
        } else if songLabel.text != nil && sender.isSelected == true {
            
            // Remove song from favorite songs.
            sender.isSelected = false
            
            // Set song label.
            let song = songLabel.text
            
            // Remove song from array.
            italianRadio.removeFavorite(song: song!)
            
        } else if songLabel.text == nil {
            
            // Animate play button.
            animateButton(button: playPauseButton)
            
        } else {
            
            // Animate play button.
            animateButton(button: playPauseButton)
        }
    }
}
