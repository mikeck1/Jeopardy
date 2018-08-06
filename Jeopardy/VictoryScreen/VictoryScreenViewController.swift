//
//  VictoryScreenViewController.swift
//  Jeopardy
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie

class VictoryScreenViewController: UIViewController {
    
    var jumpSound = AVAudioPlayer()
    var cheerSound = AVAudioPlayer()
    //Sound objects
    
    let confettiAnimation1 = LOTAnimationView(name:"confetti")
    let confettiAnimation2 = LOTAnimationView(name:"confetti")
    //Confetti objects
    
    let jumpPath = Bundle.main.path(forResource: "jump", ofType: "wav")
    let cheerPath = Bundle.main.path(forResource: "cheer", ofType: "wav")
    
    var teamScoresArray: [Team] = AppDelegate.gm.gameState.teams
    //Gets list of team names and scores from AppDelegate
    
    
    @IBOutlet weak var firstPlaceLabel: UILabel!
    
    @IBOutlet weak var secondPlaceLabel: UILabel!
    
    @IBOutlet weak var thirdPlaceLabel: UILabel!
    
    @IBOutlet weak var fourthPlaceLabel: UILabel!
    
    @IBOutlet weak var fifthPlaceLabel: UILabel!
    
    @IBOutlet weak var firstPlaceImage: UIImageView!
    
    @IBOutlet weak var secondPlaceImage: UIImageView!
    
    @IBOutlet weak var thirdPlaceImage: UIImageView!
    
    @IBOutlet weak var fourthPlaceImage: UIImageView!
    
    @IBOutlet weak var fifthPlaceImage: UIImageView!
    
    @IBAction func playAgainButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "victoryScreenSegue", sender: self)
        cheerSound.stop()
        backgroundMusic.stop()
        let path = Bundle.main.path(forResource: "QuestionData", ofType: "plist")
        AppDelegate.gm = GameMachine(path: path!)
    }
    //Segue to next screen and stop cheerSound if button is pressed

    func putScoresInLabels(){
        let sortedTeamScores: [Team] = teamScoresArray.sorted(by: {$0.score > $1.score})
    
        firstPlaceLabel.text = "\(sortedTeamScores[0].name) \(sortedTeamScores[0].score)"
        secondPlaceLabel.text = "\(sortedTeamScores[1].name) \(sortedTeamScores[1].score)"
        thirdPlaceLabel.text = "\(sortedTeamScores[2].name) \(sortedTeamScores[2].score)"
        fourthPlaceLabel.text = "\(sortedTeamScores[3].name) \(sortedTeamScores[3].score)"
        fifthPlaceLabel.text = "\(sortedTeamScores[4].name) \(sortedTeamScores[4].score)"
    }
    //sorted(by: ) sorts array by score
    //Scores are then put into the correct label by using the indicies of sortedTeamScores
    
    func hideLabelsAndImages(){
        firstPlaceLabel.isHidden = true
        secondPlaceLabel.isHidden = true
        thirdPlaceLabel.isHidden = true
        fourthPlaceLabel.isHidden = true
        fifthPlaceLabel.isHidden = true
        firstPlaceImage.isHidden = true
        secondPlaceImage.isHidden = true
        thirdPlaceImage.isHidden = true
        fourthPlaceImage.isHidden = true
        fifthPlaceImage.isHidden = true
    }
    //Hides all labels and images
    
    func playJumpSound(){
        do {
            try jumpSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: jumpPath!))
            jumpSound.play()
        } catch {
            print("Could not load file")
        }
    }
    //Plays jump sound
    
    func displayLabels(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.firstPlaceLabel.isHidden = false
            self.firstPlaceImage.isHidden = false
            self.playJumpSound()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.secondPlaceLabel.isHidden = false
            self.secondPlaceImage.isHidden = false
            self.playJumpSound()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.thirdPlaceLabel.isHidden = false
            self.thirdPlaceImage.isHidden = false
            self.playJumpSound()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.fourthPlaceLabel.isHidden = false
            self.fourthPlaceImage.isHidden = false
            self.playJumpSound()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.fifthPlaceLabel.isHidden = false
            self.fifthPlaceImage.isHidden = false
            self.playJumpSound()
        }
    }
    //Displays labels and images after certain amount of time and plays sound effect
    
    func playAnimation()
    {
        confettiAnimation1.frame = CGRect(x: 50, y: 0, width: 400, height: 400)
        confettiAnimation2.frame = CGRect(x: 900, y: 0, width: 400, height: 400)
        confettiAnimation1.loopAnimation = true
        confettiAnimation2.loopAnimation = true
        self.view.addSubview(confettiAnimation1)
        self.view.addSubview(confettiAnimation2)
        confettiAnimation1.play()
        confettiAnimation2.play()
    }
    //Displays confetti animation
    
    func playCheerSound(){
        do {
            try cheerSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: cheerPath!))
            cheerSound.play()
        } catch {
            print("Could not load file")
        }
    }
    //Play cheer sound
    
    override func viewDidLoad() {
        super.viewDidLoad()
        putScoresInLabels()
        hideLabelsAndImages()
        displayLabels()
        playCheerSound()
        playAnimation()
        // Do any additional setup after loading the view.
    }
    //Scores are put into corrects labels, labels and images first appear hidden then are unhidden, sounds and animations start

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
