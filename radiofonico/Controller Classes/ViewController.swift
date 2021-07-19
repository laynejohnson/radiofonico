//
//  ViewController.swift
//  radiofonico
//
//  Created by Layne Johnson on 5/14/21.
//  Copyright © 2021. All rights reserved.

/*
 
 Music credit: Beats in Space Radio
 
 https://www.mixcloud.com/bisradio/bis-radio-show-1072-with-il-quadro-di-troisi-donato-dozzy-eva-geist/
 
 TRACKLIST: 1. Mango-Bella d’estate 2. Lucio Dalla-Washington 3. Franco Battiato-Summer on a Solitary Beach 4. Lucio Battisti-Rilassati ed Ascolta 5. Matia Bazar-Palestina-1983 Ariston6. Krisma-Samora Club7. Paolo Tofani-Un Altro Universo 8. Alice-Chan-Son Egocentrique 9. Giuni Russo-Buenos Aires10. Enrico Ruggeri-Polvere CGD11. Anna Oxa-Uragano e Nuvole 12. Garbo-A Berlino Va Bene 13. Righeira-Disco Volante 14. Gaznevada-Agente Speciale 15. Mike Francis-Survivor16. Marcella Bella-Nell’Aria 17. Teresa De Sio-Voglia E Turna
 
 */

import UIKit
import AVFoundation

// MARK: - Dev TODOs:

// ---------------------------------- //
// - - - - - - - DEV TODO - - - - - - //
// ---------------------------------- //

// TODO: Implement repeat function
// TODO: Refactor play/pause to pause/play current song. Do not reset to [0].
// TODO: Refactor with Song class

// TODO: Add animated launch screen

// TODO: Refactor to remove song return


class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // ---------------------------------- //
    // - - - - - - -  OUTLETS - - - - - - //
    // ---------------------------------- //
    
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var songTimeLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var manoButton: UIButton!
    
    // IBOutlet for italy animation
    //    @IBOutlet weak var imageItaly: UIImageView!
    
    
    // MARK: - Variables
    
    // ---------------------------------- //
    // - - - - - - -  VARS - - - - - - -  //
    // ---------------------------------- //
    
    let italianRadio = ItalianRadioModel()
    var timer: Timer?
    
    let defaultSongLabel = " "
    let defaultArtistLabel = " "
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        songLabel.text = ""
        artistLabel.text = ""
        
        albumArt.image = #imageLiteral(resourceName: "premi_play_v2")
        
        elapsedTimeLabel.text = "00:00"
        songTimeLabel.text = "00:00"
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        guard let audioPlayer = audioPlayer else { return }
//        progressBar.value = 0.0
//        progressBar.maximumValue = Float(audioPlayer.duration)
//        audioPlayer.play()
//        timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
//
//    }
//
    //MARK: - Animations
    
//    // Serial image animation
//    func animatedImages(for name: String) -> [UIImage] {
//
//        var i = 0
//        var images = [UIImage]()
//
//        while let image = UIImage(named: "\(i)") {
//            images.append(image)
//            i += 1
//        }
//
//        return images
//    }
    
    // Scale animation for buttons
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
    
    // Set mano icon
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
        progressBar.value = Float(audioPlayer.currentTime)
        let remainingTimeInSeconds = audioPlayer.duration - audioPlayer.currentTime
        songTimeLabel.text = getFormattedTime(timeInterval: remainingTimeInSeconds)
        elapsedTimeLabel.text = getFormattedTime(timeInterval: audioPlayer.currentTime)
    }
    
    // MARK: - IBActions
    
    // ---------------------------------- //
    // - - - - - - - ACTIONS - - - - - - - //
    // ---------------------------------- //
    
    @IBAction func progressValueChanged(_ sender: UISlider) {
        
        if italianRadio.isPlaying == true {
        
        audioPlayer?.currentTime = Float64(progressBar.value)
            
        }
    }
    
    
    @IBAction func playPreviousSong(_ sender: UIButton) {
        
        if italianRadio.isPlaying == false && songLabel.text == "" {
            
            animateButton(button: playPauseButton)
            
        } else if italianRadio.isPlaying == true {
            
            let song = italianRadio.playPreviousSong()
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
            
            let isFavorite = italianRadio.checkFavorite(song: song)
            
            setMano(status: isFavorite)
            
        } else {
            
            animateButton(button: playPauseButton)
            
        }
    }
    
    @IBAction func playPauseRadio(_ sender: UIButton) {
        
        let song = italianRadio.radioOnOff(sender: sender)
        
        if song == defaultSongLabel {

            // Flash play button
            animateButton(button: playPauseButton)

        } else {

            // Set song label
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)

            // Check song favorite status
            let isFavorite = italianRadio.checkFavorite(song: song)

            // Set mano
            setMano(status: isFavorite)
        }

        if italianRadio.isPlaying == true {
            
            albumArt.image = #imageLiteral(resourceName: "album_art")
            
            progressBar.value = 0.0
            progressBar.maximumValue = Float(audioPlayer!.duration)
            
            timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
            
        }

        // Italy animation

        //        // Start animation on play
        //        imageItaly.animationImages = animatedImages(for: "radiofonico")
        //        imageItaly.animationDuration = 7
        //        imageItaly.animationRepeatCount = 0
        //        imageItaly.image = imageItaly.animationImages?.first
        //        imageItaly.startAnimating()
        //
        //        // Stop animation on pause
        //        if italianRadio.isPlaying == false {
        //            imageItaly.stopAnimating()
        //        }
        
    }
    
    @IBAction func playNextSong(_ sender: UIButton) {
        
        if italianRadio.isPlaying == false && songLabel.text == "" {
            
            animateButton(button: playPauseButton)
            
        } else if italianRadio.isPlaying == true {
            
            // Get next song
            let song = italianRadio.playNextSong()
            italianRadio.setSongLabel(song: song, songLabel: songLabel, artistLabel: artistLabel)
            
            // Check favorite status
            let isFavorite = italianRadio.checkFavorite(song: song)
            
            // Set mano
            setMano(status: isFavorite)
            
        } else {
            
            animateButton(button: playPauseButton)
        }
    }
    
    @IBAction func replaySong(_ sender: UIButton) {
        
        if songLabel.text == "" {
            // Animate play button
            animateButton(button: playPauseButton)
        } else {
            sender.isSelected.toggle()
        }
        
    }
    
    @IBAction func addFavorite(_ sender: UIButton) {
        
        if songLabel.text == "" {
            // Animate play button
            animateButton(button: playPauseButton)
        }
        
        else if songLabel.text != nil && songLabel.text != defaultSongLabel && sender.isSelected == false {
            
            // Favorite current song
            sender.isSelected = true
            
            let song = songLabel.text
            
            italianRadio.addFavorite(song: song!)
            
        } else if songLabel.text != nil && sender.isSelected == true {
            // Remove song from favorites
            sender.isSelected = false
            
            let song = songLabel.text
            
            italianRadio.removeFavorite(song: song!)
            
        } else if songLabel.text == nil {
            // Animate play button
            animateButton(button: playPauseButton)
            
        } else {
            // Animate play button
            animateButton(button: playPauseButton)
        }
    }
    
} // END ViewController Class

