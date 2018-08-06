//
//  TeamSetupViewController.swift
//  Jeopardy
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit
import AVFoundation

var backgroundMusic = AVAudioPlayer()
//Global variable declared to prevent backgroundMusic from overlaying itself everytime the game is played again. See playAgainButtonPressed(_ sender: Any) in VictoryScreenViewContoller

class TeamSetupViewController: UIViewController, UITextFieldDelegate {
    
    var path = Bundle.main.path(forResource: "SpongebobTrap", ofType: "mp3")
    
    var teamName = 0
    //Counter to iterate through teamLabelArray
    
    @IBOutlet weak var teamNameProgressBar: UIProgressView!
    
    @IBOutlet weak var poonamImage: UIImageView!
    
    @IBOutlet weak var rasikaImage: UIImageView!
    
    @IBOutlet weak var firstTeamLabel: UILabel!
    
    @IBOutlet weak var secondTeamLabel: UILabel!
    
    @IBOutlet weak var thirdTeamLabel: UILabel!
    
    @IBOutlet weak var fourthTeamLabel: UILabel!
    
    @IBOutlet weak var fifthTeamLabel: UILabel!
    
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var teamTextField: UITextField!
    
    @IBOutlet weak var addTeamButton: UIButton!
    
    var teamLabelArray: [UILabel] = []
    
    @IBAction func addTeamButtonPressed(_ sender: Any) {
        if((teamTextField.text?.isEmpty)! || (teamTextField.text?.count)! > 16){
            displayAlert()
        }else{
            AppDelegate.gm.addTeam(name: teamTextField.text!)
            incrementProgressView()
            teamLabelArray[teamName].text = teamTextField.text
            teamLabelArray[teamName].isHidden = false
            teamName = teamName + 1
            clearTextField()
            displayStartGameButton()

        }
    }
    //If textfield is empty or if a team's name is over 16 characters, an alert will pop up
    //Otherwise name is passed to AppDelegate and assigned to the correct label
    //Progress view gets incremented
    //The label will be revealed and teamName gets incremented by 1 and both clearTextField() and displayStartGameButton() are called
    
    @IBAction func startGameButtonPressed(_ sender: UIButton){
           self.performSegue(withIdentifier: "teamSetupSegue", sender: self)
           startGame()
    }
    //Segues to next view controller
    
    private func animateImages() {
        let poonamImages: [UIImage] = [#imageLiteral(resourceName: "poonam 1"),#imageLiteral(resourceName: "poonam 2")]
        let rasikaImages: [UIImage] = [#imageLiteral(resourceName: "rasika 1"), #imageLiteral(resourceName: "rasika 2")]
        
        poonamImage.image = UIImage.animatedImage(with: poonamImages, duration: 1)
        rasikaImage.image = UIImage.animatedImage(with: rasikaImages, duration: 1)
    }
    //Alternates between two images to make them appear to be moving back and forth
    
    func clearTextField(){
        teamTextField.text = ""
    }
    //Clears text field for user after a name is put in
    
    func incrementProgressView(){
        switch teamName{
        case 0:
             teamNameProgressBar.setProgress(0.2, animated: true)
        case 1:
             teamNameProgressBar.setProgress(0.4, animated: true)
        case 2:
             teamNameProgressBar.setProgress(0.6, animated: true)
        case 3:
             teamNameProgressBar.setProgress(0.8, animated: true)
        case 4:
             teamNameProgressBar.setProgress(1, animated: true)
        default:
            break
        }
    }
    //Progress bar that tracks how many teams have been input
    
    func displayAlert(){
        let alert = UIAlertController(title: "Please input a team name", message: "Team name cannot be blank or over 15 characters", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    //Pop up alert to tell user to edit their name
    
    func displayStartGameButton(){
        if teamName == 5{
            addTeamButton.isEnabled = false
            startGameButton.isHidden = false
        }
    }
    //Start button is displayed once counter reaches 5, addTeamButton is disabled after teamNames = 5 to prevent an index out of bounds error
    
    func playBackgroundMusic(){
        do {
            try backgroundMusic = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            backgroundMusic.numberOfLoops = -1
            backgroundMusic.play()
        } catch {
            print("Could not load file")
        }
    }
    //Background music is played
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if teamName < 5{
            addTeamButtonPressed(self)
            return true
        }else{
            return false
        }
    }
    //Allows user to press enter to add name in text field rather than always pressing "+" button.  Enter is disabled after teamNames = 5 to prevent an index out of bounds error
    
    func startGame(){
        AppDelegate.gm.startGame()
    }
    //Changes gameState
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playBackgroundMusic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.teamTextField.delegate = self
        animateImages()
        
        teamLabelArray = [firstTeamLabel, secondTeamLabel,thirdTeamLabel,fourthTeamLabel,fifthTeamLabel]
        
        firstTeamLabel.isHidden = true
        secondTeamLabel.isHidden = true
        thirdTeamLabel.isHidden = true
        fourthTeamLabel.isHidden = true
        fifthTeamLabel.isHidden = true
        startGameButton.isHidden = true

        // Do any additional setup after loading the view.
    }
    //Images are animated
    //Team label array gets filled with the labels
    //All labels for the team names are hidden in the beginning

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
