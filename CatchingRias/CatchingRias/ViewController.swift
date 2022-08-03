//
//  ViewController.swift
//  CatchingRias
//
//  Created by Ranjan Akarsh on 04/08/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var rias1: UIImageView!
    @IBOutlet weak var rias2: UIImageView!
    @IBOutlet weak var rias3: UIImageView!
    @IBOutlet weak var rias4: UIImageView!
    @IBOutlet weak var rias5: UIImageView!
    @IBOutlet weak var rias6: UIImageView!
    @IBOutlet weak var rias7: UIImageView!
    @IBOutlet weak var rias8: UIImageView!
    @IBOutlet weak var rias9: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    var arrayOfRias = [UIImageView]()
    
    var currentDisplayedImage: UIImageView?
    var currentScore: Int = 0
    var currentTime: Int = 30
    var countDown = Timer()
    var hasAlreadyTapped: Bool = false
    
    let KEY_HIGHSCORE: String = "catchingrias_highscore"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load user high score
        // will automatically set to 0 if high score does not exist
        let highScore = UserDefaults.standard.integer(forKey: KEY_HIGHSCORE)
        self.highScoreLabel.text = "highscore: \(highScore)"
        
        // apply all neccessary steps
        self.applyInteraction()
        self.applyGesture()
        self.renderList()
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        print("game started!")
        
        self.startCatchingRias()
    }
    
    private func startCatchingRias() {
        // hide button
        self.startButton.isHidden = true
        self.startButton.isEnabled = true

        
        self.countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerInterval), userInfo: nil, repeats: true)
        
        // hide all image
        for rias in self.arrayOfRias {
            rias.alpha = 0.0
        }
    }
    
    private func applyInteraction() {
        // apply interaction ability to all of rias's image
        rias1.isUserInteractionEnabled = true
        rias2.isUserInteractionEnabled = true
        rias3.isUserInteractionEnabled = true
        rias4.isUserInteractionEnabled = true
        rias5.isUserInteractionEnabled = true
        rias6.isUserInteractionEnabled = true
        rias7.isUserInteractionEnabled = true
        rias8.isUserInteractionEnabled = true
        rias9.isUserInteractionEnabled = true
    }
    
    private func applyGesture() {
        // initialize and assign each rias's image with gestures
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(tappedOnRias))
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(tappedOnRias))
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(tappedOnRias))
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(tappedOnRias))
        let gesture5 = UITapGestureRecognizer(target: self, action: #selector(tappedOnRias))
        let gesture6 = UITapGestureRecognizer(target: self, action: #selector(tappedOnRias))
        let gesture7 = UITapGestureRecognizer(target: self, action: #selector(tappedOnRias))
        let gesture8 = UITapGestureRecognizer(target: self, action: #selector(tappedOnRias))
        let gesture9 = UITapGestureRecognizer(target: self, action: #selector(tappedOnRias))

        rias1.addGestureRecognizer(gesture1)
        rias2.addGestureRecognizer(gesture2)
        rias3.addGestureRecognizer(gesture3)
        rias4.addGestureRecognizer(gesture4)
        rias5.addGestureRecognizer(gesture5)
        rias6.addGestureRecognizer(gesture6)
        rias7.addGestureRecognizer(gesture7)
        rias8.addGestureRecognizer(gesture8)
        rias9.addGestureRecognizer(gesture9)
    }
    
    private func renderList() {
        // load array of Rias
        self.arrayOfRias = [
            rias1,
            rias2,
            rias3,
            rias4,
            rias5,
            rias6,
            rias7,
            rias8,
            rias9
        ]
    }
    
    private func displayGameEnd() {
        let alert = UIAlertController(title: "time's up!", message: "do you want to replay?", preferredStyle: .alert)
        let done = UIAlertAction(title: "done", style: .default) { _ in
            self.startButton.isHidden = false
            self.startButton.isEnabled = true
            
            for rias in self.arrayOfRias {
                rias.alpha = 1.0
            }
        }
        
        let replay = UIAlertAction(title: "replay", style: .cancel) { _ in
            self.startCatchingRias()
        }
        
        alert.addAction(done)
        alert.addAction(replay)
        
        self.present(alert, animated: true)
    }
    
    @objc func tappedOnRias() {
        if !self.hasAlreadyTapped {
            self.currentScore += 1
        }
        
        self.hasAlreadyTapped = true
        self.currentScoreLabel.text = "Score: \(self.currentScore)"
    }
    
    @objc func timerInterval() {
        self.currentTime -= 1
        self.timerLabel.text = "Timer: \(self.currentTime)"
        
        // perform randomization
        let nNumber = Int.random(in: 1...9)
        for (idx, rias) in self.arrayOfRias.enumerated() {
            if idx + 1 == nNumber {
                rias.alpha = 1.0
            } else {
                rias.alpha = 0.0
            }
        }

        self.hasAlreadyTapped = false // to avoid clicking same rias more than once

        if self.currentTime == 0 {
            self.countDown.invalidate()
            
            // check highscore against saved value
            let highScore = UserDefaults.standard.integer(forKey: KEY_HIGHSCORE)
            if self.currentScore > highScore {
                UserDefaults.standard.set(self.currentScore, forKey: KEY_HIGHSCORE)
                self.highScoreLabel.text = "highscore: \(self.currentScore)"
            }
            
            self.displayGameEnd()
        }
    }

}

