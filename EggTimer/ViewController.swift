//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer!
    //UI elements to handle
    @IBOutlet weak var progressBarValue: UIProgressView!
    @IBOutlet weak var titleLebel: UILabel!
    @IBOutlet weak var stopAlarmButton: UIButton!
    
    //Values to be used across class
    let eggTime = ["Soft":      300,
                   "Medium":    420,
                   "Hard":      720]
    var secondsRemaining = 60
    var timer = Timer()
    var decrementValue: Float = 0.0
    

    //Set Initial View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialTitle()
        self.setInitialProgressBar()
        self.setStopAlarmButtonInitialStage()
    }
    
    //Actions triggered by Buttons
    //Perform the steps to be done after hardness selected
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        setStopAlarmButtonInitialStage()
        
        let hardness = sender.currentTitle!
        secondsRemaining = eggTime[hardness]!
        progressBarValue.progress = 1.0
        decrementValue = progressBarValue.progress/Float(secondsRemaining)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDownTimer), userInfo: nil, repeats: true)
    }
    @IBAction func stopAlarm(_ sender: Any) {
        stopSound()
    }
    
    //Objective C function for timer
    @objc func countDownTimer(){
        if secondsRemaining >= 0 {
            secondsRemaining -= 1
            progressBarValue.progress -= decrementValue
        }
        else {
            timer.invalidate()
            titleLebel.text = "Done !"
            playSound(soundName: "serviceBell")
        }
    }
    
    
    //function to play alarm
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "wav")
        self.player = try! AVAudioPlayer(contentsOf: url!)
        self.player.play()
        self.player.numberOfLoops = -1
        
        setStopAlarmButtonActiveStage()
    }
    
    //function to stop alarm & set stop button to initial stage
    func stopSound (){
        self.player.stop()
        setStopAlarmButtonInitialStage()
        setInitialTitle()
    }

    
    //Control Button Stage
    func setStopAlarmButtonInitialStage(){
        stopAlarmButton.isEnabled = false
        stopAlarmButton.alpha = 0.0
    }
    func setStopAlarmButtonActiveStage(){
        stopAlarmButton.isEnabled = true
        stopAlarmButton.alpha = 1.0
    }
    
    //Set Initial title stage
    func setInitialTitle(){
        titleLebel.text = "How do you like your eggs?"
    }
    
    func setInitialProgressBar(){
        progressBarValue.progress = 0.0
    }
}
