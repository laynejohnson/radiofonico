//
//  BenvenutiViewController.swift
//  radiofonico
//
//  Created by Layne Johnson on 8/7/21.
//

import UIKit

class BenvenutiViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var manoImageView: UIImageView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Hide navigation bar.
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Animate RadioFonico icon.
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn , animations: {
            self.manoImageView.transform = CGAffineTransform(translationX: 0, y: 10)
        })
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionCrossDissolve, animations: {
            self.manoImageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .transitionCrossDissolve, animations: {
            self.manoImageView.image = UIImage(named:"mano_heart_lg")

        })
        
        // Segue to music player.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.performSegue(withIdentifier: Constants.Segues.musicPlayerSegue, sender: self )
        })
    }
}
