//
//  AnsweringScreenViewController.swift
//  Jeopardy
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//



import UIKit
import AVFoundation

class AnsweringScreenViewController: UIViewController
{
    // creating a Question type object
    var questionInfo : Question!
    
    // Manage Alert Pop-Up
    var alertTitle: String = "TIME IS UP"
    var alertMessage: String = "Select whether the team was correct or incorrect."
    var alertActionButtonMessage: String = "OK"
    
    // Timer Vars
    var maxTimer: Int = 0              // initialize, but manipulate in getQuestionData()
    var timeRemaining: Int = 0          // time which will be reduced each incorrect guess
    var reduceTimeDivider: Int = 1      // will be manipulated inside of IncorrectButtonPressed() to reduce time by half each time
    var hasNoTimeLimit: Bool = false    // handles case where time is initialized to zero
    var timer = Timer()                 // Timer object
    
    // Points
    var pointsForQuestion: Int = 0      // initialize, but manipulate in getQuestionData()
    
    // Incorrect Team Guesses Count
    var countIncorrect: Int = 0
    
    // Correct and Incorrect Answer Buttons
    @IBOutlet weak var CorrectAnswerButton: UIButton!
    @IBOutlet weak var IncorrectAnswerButton: UIButton!
    
    // Timer and Question Labels
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var PromptQuestionLabel: UILabel!
    
    // Team Name Labels
    @IBOutlet weak var TeamName1Label: UILabel!
    @IBOutlet weak var TeamName2Label: UILabel!
    @IBOutlet weak var TeamName3Label: UILabel!
    @IBOutlet weak var TeamName4Label: UILabel!
    @IBOutlet weak var TeamName5Label: UILabel!
    
    // Team Score Labels
    @IBOutlet weak var TeamScore1Label: UILabel!
    @IBOutlet weak var TeamScore2Label: UILabel!
    @IBOutlet weak var TeamScore3Label: UILabel!
    @IBOutlet weak var TeamScore4Label: UILabel!
    @IBOutlet weak var TeamScore5Label: UILabel!
    
    // Category Label
    @IBOutlet weak var CategoryLabel: UILabel!
    
    // Team UIImageViews to Indicate Answering Team
    @IBOutlet weak var purpleBorder1: UIImageView!
    @IBOutlet weak var purpleBorder2: UIImageView!
    @IBOutlet weak var purpleBorder3: UIImageView!
    @IBOutlet weak var purpleBorder4: UIImageView!
    @IBOutlet weak var purpleBorder5: UIImageView!
    
    // Bool to check if user gets answer correct within changeScreens() func
    var isCorrect: Bool = false
    
    // Bool to check if halfTheTimer() is called; will allow us to notify teams when time has changed
    var switchColor: Bool = false
    
    // Object to play sound/music
    var player: AVAudioPlayer?
    var pickSound: Int = 0
    
    // Set Team Names and Scores
    func setTeamInfoLabels()
    {
        TeamName1Label.text = "\(AppDelegate.gm.gameState.teams[0].name)"
        TeamScore1Label.text = "\(AppDelegate.gm.gameState.teams[0].score)"
        
        TeamName2Label.text = "\(AppDelegate.gm.gameState.teams[1].name)"
        TeamScore2Label.text = "\(AppDelegate.gm.gameState.teams[1].score)"
        
        TeamName3Label.text = "\(AppDelegate.gm.gameState.teams[2].name)"
        TeamScore3Label.text = "\(AppDelegate.gm.gameState.teams[2].score)"
        
        TeamName4Label.text = "\(AppDelegate.gm.gameState.teams[3].name)"
        TeamScore4Label.text = "\(AppDelegate.gm.gameState.teams[3].score)"
        
        TeamName5Label.text = "\(AppDelegate.gm.gameState.teams[4].name)"
        TeamScore5Label.text = "\(AppDelegate.gm.gameState.teams[4].score)"
        
    }
    
    // Access the data from a certain question
    func getQuestionData()
    {
        // get and set the time for question
        maxTimer = questionInfo.maxTime
        timeRemaining = questionInfo.maxTime
        TimerLabel.text = "\(maxTimer)"
        
        // if we are given an initial time limit of 0, then there is no time limit
        if(maxTimer == 0)
        {
            hasNoTimeLimit = true
        }
        else
        {
            hasNoTimeLimit = false
        }
        
        // set question label
        PromptQuestionLabel.text = questionInfo.text
        
    }
    
    // Place the names of certain team to announce their turn
    func animateNextTeam()
    {
        let category: String = questionInfo.category.uppercased()
        
        // Display category and points
        CategoryLabel.text = "Category: \(category), Points: \(questionInfo.pointValue)"

        // Hide all teams' borders
        purpleBorder1.alpha = 0
        purpleBorder2.alpha = 0
        purpleBorder3.alpha = 0
        purpleBorder4.alpha = 0
        purpleBorder5.alpha = 0
        
        // Display only the answering team's border
        switch AppDelegate.gm.gameState.indexOfAnsweringTeam
        {
        case 0:
            purpleBorder1.alpha = 1
        case 1:
            purpleBorder2.alpha = 1
        case 2:
            purpleBorder3.alpha = 1
        case 3:
            purpleBorder4.alpha = 1
        case 4:
            purpleBorder5.alpha = 1
        default:
            break
        }
    }
    
    // Reset the counters/dividers/timer
    func resetLogic()
    {
        countIncorrect = 0
        timer.invalidate()
        reduceTimeDivider = 1
    }
    
    // Returns TRUE - if we are out of questions
    // Returns FALSE - if there are still questions
    func outOfQuestions() -> Bool
    {
        if(AppDelegate.gm.qr.getQuestionsRemaining() == 0)
        {
            return true
        }
        return false
    }
    
    // Checks if we have run out of questions OR all teams answered wrong
    // Switches screens accordingly...
    func changeScreens()
    {
        if((outOfQuestions()) && (isCorrect == true))
        {
            performSegue(withIdentifier: "victoryScreenSegue", sender: self)
        }
        else if((outOfQuestions()) && (countIncorrect == 5))
        {
            performSegue(withIdentifier: "victoryScreenSegue", sender: self)
        }
        else if((countIncorrect == 5) || (isCorrect == true))
        {
            resetLogic()
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            return
        }
    }
    
    // Team Answered Incorrectly
    @IBAction func IncorrectButtonPressed(_ sender: UIButton)
    {
        countIncorrect += 1
        AppDelegate.gm.answeredQuestion(withCorrectAnswer: false)
        isCorrect = false
        pickSound = 0
        playSound(pickSound: pickSound) // buzzer sound
        
        if(countIncorrect < 5)
        {
            animateNextTeam()
            halfTheTimer()
            runTimer()
        }
        changeScreens()
    }
    
    // Teams Answered Correctly
    @IBAction func CorrectButtonPressed(_ sender: UIButton)
    {
        isCorrect = true
        resetLogic()
        AppDelegate.gm.answeredQuestion(withCorrectAnswer: true)
        pickSound = 1
        playSound(pickSound: pickSound)     // ding sound
        changeScreens()
    }
    
    // Reduce the Timer by half
    func halfTheTimer()
    {
        timer.invalidate()
        reduceTimeDivider = reduceTimeDivider * 2
        timeRemaining = maxTimer / reduceTimeDivider
        
        switchColor = !switchColor      // toggle
    } 
    
    // Run the timer
    func runTimer()
    {
        if((hasNoTimeLimit == true) && (isCorrect == false))
        {
            TimerLabel.text = "NO TIME LIMIT"
            TimerLabel.textColor = UIColor.red
            return
        }
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: (#selector(AnsweringScreenViewController.updateTimer)),
            userInfo: nil,
            repeats: true
        )
    }
    
    // Decrement the Timer
    @objc func updateTimer()
    {
        while(timeRemaining != 0)
        {
            timeRemaining -= 1
            
            if(switchColor == true)
            {
                TimerLabel.textColor = UIColor.blue
            }
            else
            {
                TimerLabel.textColor = UIColor.purple
            }
            
            TimerLabel.text = "\(timeRemaining)"
            
            if(timeRemaining <= 10)
            {
                TimerLabel.textColor = UIColor.red
                pickSound = 2
                playSound(pickSound: pickSound)     // tick sound
                
                if(timeRemaining % 2 == 0)
                {
                    TimerLabel.font = UIFont.systemFont(ofSize: 40.0, weight: UIFont.Weight.black)
                }
                else
                {
                    TimerLabel.font = UIFont.systemFont(ofSize: 80.0, weight: UIFont.Weight.heavy)
                }
            }
            
            return
        }
        timer.invalidate()
        createAlert(title: alertTitle, message: alertMessage)
    }
    
    // Send alert to Game Administrators
    func createAlert(title: String, message: String)
    {
        // Creating an alert that receives a title and message that will be displayed
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Setting an "OK" action button to dismiss alert
        alert.addAction(UIAlertAction(title: alertActionButtonMessage, style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)}))
        
        // Display the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // play right or wrong buzzer sound
    func playSound(pickSound: Int)
    {
        // just initializing urlSound; SpongebobTrap won't be used
        var urlSound = Bundle.main.url(forResource: "SpongebobTrap", withExtension: "mp3")
        
        switch pickSound
        {
        case 0:
            urlSound = Bundle.main.url(forResource: "wrongAnswer", withExtension: "mp3")
        case 1:
            urlSound = Bundle.main.url(forResource: "rightAnswer", withExtension: "mp3")
        case 2:
            urlSound = Bundle.main.url(forResource: "tickSound", withExtension: "mp3")
        default:
            break
        }
        
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: urlSound!, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        resetLogic()
        
        // initialize questionPath obj
        let questionPath = AppDelegate.gm.gameState.currentQuestion!
        
        // send questionPath obj to retrieve question data
        self.questionInfo = AppDelegate.gm.qr.questionAt(questionPath: questionPath)
        getQuestionData()
        setTeamInfoLabels()
        animateNextTeam()
        runTimer()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
