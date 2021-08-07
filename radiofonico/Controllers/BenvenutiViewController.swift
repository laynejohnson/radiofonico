//
//  BenvenutiViewController.swift
//  radiofonico
//
//  Created by Layne Johnson on 8/7/21.
//

import UIKit

class BenvenutiViewController: UIViewController {
    
    @IBOutlet weak var manoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn , animations: {
            self.manoImageView.transform = CGAffineTransform(translationX: 0, y: 10)
        })
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionCrossDissolve, animations: {
            self.manoImageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .transitionCrossDissolve, animations: {
            self.manoImageView.image = UIImage(named:"mano_heart_lg")
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.performSegue(withIdentifier: Constants.musicPlayerSegue, sender: self )
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.dismiss(animated: false, completion: nil)
    }
    
}