//
//  ViewController.swift
//  radiofonico
//
//  Created by Layne Johnson on 5/14/21.
//  Copyright © 2021. All rights reserved.

import UIKit
import AVFoundation

class RadioViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // Song and album view.
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    // Progress bar.
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var songLengthLabel: UILabel!
    
    // Radio controls.
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Variables
    
    let italianRadio = RadioModel()
    var timer: Timer?
    
    let song = " "
    let defaultSongLabel = " "
    let defaultArtistLabel = " "
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default image/labels.
        albumArt.image = #imageLiteral(resourceName: "premi_play_v2")
        songLabel.text = ""
        artistLabel.text = ""
        elapsedTimeLabel.text = "00:00"
        songLengthLabel.text = "00:00"
        
        // Set accessibility elements.
        albumArt.isAccessibilityElement = true
        
        // Set accessibility labels. * State dependent accessibility labels set in playPauseSong() & updateProgressBar() functions.
        albumArt.accessibilityLabel = "Premi play to vibe"
        progressBar.accessibilityLabel = "Track position"
        
        elapsedTimeLabel.accessibilityLabel = "Elapsed time"
        songLengthLabel.accessibilityLabel = "Song length"
        
        previousButton.accessibilityLabel = "Previous track"
        playPauseButton.accessibilityLabel = "Play"
        nextButton.accessibilityLabel = "Next track"
        favoriteButton.accessibilityLabel = "Favorite"
        replayButton.accessibilityLabel = "Replay all"
        
        // Set accessibility language.
        albumArt.accessibilityLanguage = "it"
        songLabel.accessibilityLanguage = "it"
        artistLabel.accessibilityLanguage = "it"
        
        // Dynamic type setup.
        
        // .title2
        if let monoTitle2 = UIFont(name: "PTMono-Regular", size: 22) {
            songLabel.font = UIFontMetrics(forTextStyle: .title2 ).scaledFont(for: monoTitle2)
            
            songLabel.adjustsFontForContentSizeCategory = true
        }
        
        // .title3
        if let monoTitle3 = UIFont(name: "PTMono-Regular", size: 20) {
            artistLabel.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: monoTitle3)
            
            artistLabel.adjustsFontForContentSizeCategory = true
        }
        
        // .callout
        if let monoCallout = UIFont(name: "PTMono-Regular", size: 16) {
            elapsedTimeLabel.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: monoCallout)
            separatorLabel.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: monoCallout)
            songLengthLabel.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: monoCallout)
            
            elapsedTimeLabel.adjustsFontForContentSizeCategory = true
            separatorLabel.adjustsFontForContentSizeCategory = true
            songLengthLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Animations
    
    func animateButton(button: UIButton) {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            button.transform = .init(scaleX: 1.25, y: 1.25)
        }) { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                button.transform = .identity
            })
        }
    }
    
    // MARK: - UI Functions
    
    func setFavorite(status: Bool) {
        if status == true {
            favoriteButton.isSelected = true
            
        } else {
            favoriteButton.isSelected = false
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
        
        let duration = getFormattedTime(timeInterval: audioPlayer.duration)
        let elapsedTime = getFormattedTime(timeInterval: audioPlayer.currentTime)
        
        progressBar.value = Float(audioPlayer.currentTime)
        
        songLengthLabel.text = duration
        elapsedTimeLabel.text = elapsedTime
        
        // Set accessibility labels.
        songLengthLabel.accessibilityLabel = "Song length"
        songLengthLabel.accessibilityValue = duration
        elapsedTimeLabel.accessibilityLabel = "Elapsed time"
        elapsedTimeLabel.accessibilityValue = elapsedTime
        
        // Set accessibility value.
        progressBar.accessibilityValue = "\(elapsedTime) of \(duration)"
    }
    
    // MARK: - IBActions
    
    @IBAction func progressValueChanged(_ sender: UISlider) {
        if italianRadio.isPlaying == true {
            audioPlayer?.currentTime = Float64(progressBar.value)
        }
    }
    
    // TODO: ADD RESUME FROM TIMESTAMP.
    @IBAction func playPauseSong(_ sender: UIButton) {
        let song = italianRadio.playPauseRadio(sender: sender)
        
        if song == defaultSongLabel {
            animateButton(button: playPauseButton)
            
        } else {
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
            
            let isFavorite = italianRadio.checkFavorite(song: song)
            setFavorite(status: isFavorite)
        }
        
        if italianRadio.isPlaying == true {
            albumArt.image = #imageLiteral(resourceName: "album_art")
            
            // Set accessibility labels.
            albumArt.accessibilityLabel = "Il quadro di troisi album art"
            albumArt.accessibilityLanguage = "it"
            playPauseButton.accessibilityLabel = "Pause"
            
            progressBar.value = 0.0
            progressBar.maximumValue = Float(audioPlayer!.duration)
            
            timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func playPreviousSong(_ sender: UIButton) {
        if italianRadio.isPlaying == false && songLabel.text == "" {
            animateButton(button: playPauseButton)
            
        } else if italianRadio.isPlaying == true {
            let song = italianRadio.playPreviousSong()
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
            let isFavorite = italianRadio.checkFavorite(song: song)
            setFavorite(status: isFavorite)
            
        } else {
            animateButton(button: playPauseButton)
        }
    }
    
    // TODO: IMPLEMENT AUTOPLAY NEXT.
    @IBAction func playNextSong(_ sender: UIButton) {
        if italianRadio.isPlaying == false && songLabel.text == "" {
            animateButton(button: playPauseButton)
            
        } else if italianRadio.isPlaying == true {
            let song = italianRadio.playNextSong()
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
            let isFavorite = italianRadio.checkFavorite(song: song)
            
            setFavorite(status: isFavorite)
            
        } else {
            animateButton(button: playPauseButton)
        }
    }
    // TODO: IMPLEMENT REPLAY ALL SONGS.
    @IBAction func replayAllSongs(_ sender: UIButton) {
        if songLabel.text == "" {
            animateButton(button: playPauseButton)
            
        } else {
            sender.isSelected.toggle()
        }
        
    }
    
    @IBAction func addFavorite(_ sender: UIButton) {
        if songLabel.text == "" {
            animateButton(button: playPauseButton)
            
        } else if songLabel.text != nil && songLabel.text != defaultSongLabel && sender.isSelected == false {
            sender.isSelected = true
            
            let song = songLabel.text
            italianRadio.addFavorite(song: song!)
            
        } else if songLabel.text != nil && sender.isSelected == true {
            sender.isSelected = false
            
            let song = songLabel.text
            italianRadio.removeFavorite(song: song!)
            
        } else if songLabel.text == nil {
            animateButton(button: playPauseButton)
            
        } else {
            animateButton(button: playPauseButton)
        }
    }
}
