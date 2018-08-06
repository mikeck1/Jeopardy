//
//  GameScreenViewController.swift
//  Jeopardy
//
//  GameScreenViewController class that handles the main game view
//  It sets the team names and scores to the labels and sets it to the correct font
//
//  Created by Poonam Hattangady on 7/22/18.
//  Edited by Prathyusha Pillari on 7/27/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit
import AVFoundation

class GameScreenViewController: UIViewController {

    // lables for team names
    @IBOutlet weak var teamName1: UILabel!
    @IBOutlet weak var teamName2: UILabel!
    @IBOutlet weak var teamName3: UILabel!
    @IBOutlet weak var teamName4: UILabel!
    @IBOutlet weak var teamName5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // sets the label fonts when it loads the first time
        setLabelFont()
        // sets the team names when it loads the first time
        setTeamNames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // sets the label fonts again to change the font of different answering screens
        setLabelFont()
        // sets the team names again to change the font of different answering screens
        // to reload it with new scores and fonts every time
        setTeamNames()
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* This method sets the label fonts for team names
     * @returns Nothing.
     */
    func setLabelFont(){
        // updates fonts of the teams that are not answering
        fontForTeamsNotAnswering()
        
        // updates fonts of the teams that are answering
        // bolds them and sets alpha to 1 for visibility
        switch AppDelegate.gm.gameState.indexOfChoosingTeam {
        case 0:
            teamName1.font = UIFont.boldSystemFont(ofSize: 25.0)
            teamName1.textColor  = UIColor.purple
            teamName1.alpha = 1
        case 1:
            teamName2.font = UIFont.boldSystemFont(ofSize: 25.0)
            teamName2.textColor  = UIColor.purple
            teamName2.alpha = 1
        case 2:
            teamName3.font = UIFont.boldSystemFont(ofSize: 25.0)
            teamName3.textColor  = UIColor.purple
            teamName3.alpha = 1
        case 3:
            teamName4.font = UIFont.boldSystemFont(ofSize: 25.0)
            teamName4.textColor  = UIColor.purple
            teamName4.alpha = 1
        case 4:
            teamName5.font = UIFont.boldSystemFont(ofSize: 25.0)
            teamName5.textColor  = UIColor.purple
            teamName5.alpha = 1
        default:
            teamName5.font = UIFont.boldSystemFont(ofSize: 25.0)
            teamName5.textColor  = UIColor.purple
            teamName5.alpha = 1
        }
    }
    
    /* This method sets the label fonts for team names
     * that are not answering
     * @returns Nothing.
     */
    func fontForTeamsNotAnswering(){
        teamName1.font = UIFont.systemFont(ofSize: 20.0)
        teamName1.textColor  = UIColor.black
        teamName1.alpha = 0.5
        teamName2.font = UIFont.systemFont(ofSize: 20.0)
        teamName2.textColor  = UIColor.black
        teamName2.alpha = 0.5
        teamName3.font = UIFont.systemFont(ofSize: 20.0)
        teamName3.textColor  = UIColor.black
        teamName3.alpha = 0.5
        teamName4.font = UIFont.systemFont(ofSize: 20.0)
        teamName4.textColor  = UIColor.black
        teamName4.alpha = 0.5
        teamName5.font = UIFont.systemFont(ofSize: 20.0)
        teamName5.textColor  = UIColor.black
        teamName5.alpha = 0.5
    }
    
    /* This method sets the label's team names and scores
     * @returns Nothing.
     */
    func setTeamNames(){
        // updates team names and scores
        if(AppDelegate.gm.gameState.teams.count != 0){
            teamName1.text = "\(AppDelegate.gm.gameState.teams[0].name) (\(AppDelegate.gm.gameState.teams[0].score))"
            teamName2.text = "\(AppDelegate.gm.gameState.teams[1].name) (\(AppDelegate.gm.gameState.teams[1].score))"
            teamName3.text = "\(AppDelegate.gm.gameState.teams[2].name) (\(AppDelegate.gm.gameState.teams[2].score))"
            teamName4.text = "\(AppDelegate.gm.gameState.teams[3].name) (\(AppDelegate.gm.gameState.teams[3].score))"
            teamName5.text = "\(AppDelegate.gm.gameState.teams[4].name) (\(AppDelegate.gm.gameState.teams[4].score))"
        }
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
