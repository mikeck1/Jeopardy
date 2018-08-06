//
//  GameManager.swift
//  Jeopardy
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

// Rules of the game.
// There are 3 teams playing: Team 1, Team 2, Team 3.
// The game starts in notStarted state.
//
// When teams Team 1, Team 2, and Team 3 are added, and startGame() is called,
// Game moves into choosingQuestion state with Team 1 picking first.
//
// e.g. Scenario 1:
// Team 1 picked a question with 100 points
// Team 1 gets to answer first and answers correctly.
// Team 1's score increases by 100 and Team 2 gets to pick a question next (because Team 1 picked the last question).
//
// e.g. Scenario 2:
// Team 2 picked a question with 100 points
// Team 2 gets to answer first and answers incorrectly.
// Team 3 attempts next, and answers correctly.
// Team 3's score increases by 100 and Team 3 gets to pick the next question (because Team 2 picked the last question).
//
// e.g. Scenario 3:
// Team 3 picked a question with 100 points
// Team 3 gets to answer first and answers incorrectly.
// Team 1 attempts next, and answers incorrectly.
// Team 2 attempts next, and answers incorrectly.
// No one scores. Team 1 gets to pick a question next (because Team 3 picked the last question).
//
// Eventually, when all questions are asked, the game goes into gameOver state.
//
class GameMachine {
    private(set) var gameState = GameState()
    private(set) var qr: QuestionRetriever
    
    init(path: String) {
        self.qr = QuestionRetriever(path: path)
    }
    
    // Added for unit testing
    init(qr: QuestionRetriever, gameState: GameState) {
        self.qr = qr                // GameMachine needs access to Question Retriever
        self.gameState = gameState  // Take a gamestate in to change the GameMachine instance.
    }
    
    // This function adds a team to the game state.
    
    func addTeam(name: String) {
        var tempTeamArray : [Team] = self.gameState.teams
        
                                                        // Initialize a Team with name from the database and score of zero.
        let tempTeam : Team = Team(name: name, score: 0)
        tempTeamArray.append(tempTeam)                  // Add team from file into the array of Teams
        
                                                        // Change state of GameMachine to have the new team array.
        let newState = GameState(gameStatus: .notStarted,
                                 teams: tempTeamArray,
                                 currentQuestion: QuestionPath(categoryIndex: 0, indexInCategory: 0),
                                 indexOfChoosingTeam: self.gameState.indexOfChoosingTeam,
                                 indexOfAnsweringTeam: 0)
        self.gameState = newState
    }
    
    
    // This function starts a game.
    // A game can be started only if:
    // - game hasn't been started yet
    // - AND there are at least two teams added
    // It marks the first team as choosing a question.
    
    func startGame() {
        if (self.gameState.gameStatus != .notStarted ||
            self.gameState.teams.count < 2) {
            return
        }
        
                                                        // Change state of GameMachine to start of game.
        let newState = GameState(gameStatus: .choosingQuestion,
                                 teams: self.gameState.teams,
                                 currentQuestion: QuestionPath(categoryIndex: 0, indexInCategory: 0),
                                 indexOfChoosingTeam: self.gameState.indexOfChoosingTeam,
                                 indexOfAnsweringTeam: 0)
        self.gameState = newState
    }
    
    // This function chooses a question.
    // A question can be chosen only if game is in choosingQuestion state
    // and if the question hasn't been asked already
    // It marks the question as asked.
    // It marks the choosing team as answering a question.
    // It makes this question the current question in gameState.
    // It moves the game into answeringQuestionState
    // e.g., if Team 2 chose a question, then Team 2 gets to answer the question first.
    
    func chooseQuestion(questionPath: QuestionPath) {
                                                        // Get current Question
        let tempQuestions : Question = qr.questionAt(questionPath: questionPath)
        
                                                        // If the question has not been asked
        if (tempQuestions.hasBeenAsked  == false)
        {
                                                        // Change state of GameMachine to start a new question.
            let newState = GameState(gameStatus: .answeringQuestion,
                                     teams: self.gameState.teams,
                                     currentQuestion: questionPath,
                                     indexOfChoosingTeam: self.gameState.indexOfChoosingTeam,
                                     indexOfAnsweringTeam: self.gameState.indexOfChoosingTeam )
            self.gameState = newState
            
            // Mark the Question as asked.
            qr.markQuestionAsAsked(questionPath: questionPath)
        }
        else
        {
                                                        // Change state of GameMachine to not have a question.
            let newState = GameState(gameStatus: .choosingQuestion,
                                     teams: self.gameState.teams,
                                     currentQuestion: nil,
                                     indexOfChoosingTeam: self.gameState.indexOfChoosingTeam,
                                     indexOfAnsweringTeam: self.gameState.indexOfAnsweringTeam)
            self.gameState = newState
        }
        
    }
    
                                                        // Increment a team with respect to num of teams added.

    func safeNextTeam (curentTeamIndex: Int) -> Int     // Increment or start at zero with respect to num of teams
    {
        let teamCount = self.gameState.teams.count - 1  // Get Number of team members (in 1 based)

        if (teamCount == curentTeamIndex)               // If we asked every team already
        {
            return 0                                    // Start again at zero
        }
        else                                            // Otherwise
        {
            return curentTeamIndex + 1                  // Increment to the next team index
        }
    }
    
    func clearTeamArray ()
    {
        var tempTeamArray = self.gameState.teams
        tempTeamArray.removeAll()
        
        let newState = GameState(gameStatus: .gameOver,
                                 teams: tempTeamArray,
                                 currentQuestion: nil,
                                 indexOfChoosingTeam: 0,
                                 indexOfAnsweringTeam: 0)
        self.gameState = newState
    }
    
    // This function is called when the moderator marks an answer as correct or wrong.
    // If correct, the answering team's score is increased and the next team gets to choose a question.
    //      If all questions have been asked, it goes into game over state.
    // If incorrect, the next team gets to answer the question.
    //      If all teams have attempted to answer and all got it wrong, then no one scores.
    //      The next team gets to choose a question.
    // See detailed rules at the top of this file.
    func answeredQuestion(withCorrectAnswer isCorrectAnswer: Bool) {
        
                                                        // Get constants used to understand current question.
        let currentQuestionPath : QuestionPath = self.gameState.currentQuestion!
        let currentQuestion : Question = self.qr.questionAt(questionPath: currentQuestionPath )
        let questionsRemaining : Int = qr.getQuestionsRemaining()
        
                                                        // Get constants used to understand current/ next team answering and choosing
        let currentTeamAnsweringIndex : Int = self.gameState.indexOfAnsweringTeam
        let nextTeamAnsweringIndex : Int = safeNextTeam(curentTeamIndex: currentTeamAnsweringIndex)
        let currentChoosingTeamIndex : Int = self.gameState.indexOfChoosingTeam
        // LastTeamAnsweringBool is used to determine if the current choosing team is equal to the next answering team.
        let lastTeamAnsweringBool = nextTeamAnsweringIndex == self.gameState.indexOfChoosingTeam
        
        if ( isCorrectAnswer )                          // If the current answeredQuestion is true
        {
                                                        // Give score to right team
            var tempTeamArray : [Team] = self.gameState.teams
            
                                                        // Get the next and the index of next team that will choose
            let tempNameofTeam : String = tempTeamArray[currentTeamAnsweringIndex].name
            let nextChoosingTeamIndex : Int = safeNextTeam(curentTeamIndex: currentChoosingTeamIndex)
            
            var gameStatus : GameStatus = .choosingQuestion
            if (questionsRemaining == 0)                // If the Total Questions Remaining is equal to zero
            {
                gameStatus = .gameOver                  // End the game
            }

                                                        // Get Current Team Score and Create a Temporary Team to hold this data.
            let score : Int = tempTeamArray[currentTeamAnsweringIndex].score
            let tempTeam : Team = Team(name: tempNameofTeam, score: score + currentQuestion.pointValue)
            
                                                        // Add Temporary Team to tempTeamArray
            tempTeamArray[currentTeamAnsweringIndex] = tempTeam
            
                                                        // Change state of GameMachine to the specific gameStatus.
            let newState = GameState(gameStatus: gameStatus,
                                     teams: tempTeamArray,
                                     currentQuestion: nil,
                                     indexOfChoosingTeam: nextChoosingTeamIndex,
                                     indexOfAnsweringTeam: nextChoosingTeamIndex)
            
            self.gameState = newState
            return
        }
        else                                            // If the answer was not correct
        {                                               // check to see if we are at end of teams list and no one answered
            if (lastTeamAnsweringBool)                  // If we are at the last team answering
            {
                var gameStatus : GameStatus = .choosingQuestion
                if (questionsRemaining == 0)            // Also if the Questions Remaining is zero
                {
                    gameStatus = .gameOver              // End the Game
                }
                                                        // Get the next Choosing Team Index
                let nextChoosingTeamIndex : Int = safeNextTeam(curentTeamIndex: currentChoosingTeamIndex)
                
                                                        // Change state of GameMachine to the specific gameStatus.
                let newState = GameState(gameStatus: gameStatus,
                                         teams: self.gameState.teams,
                                         currentQuestion: nil,
                                         indexOfChoosingTeam: nextChoosingTeamIndex,
                                         indexOfAnsweringTeam: nextChoosingTeamIndex)
                self.gameState = newState
                return
            }
            else
            {
                                                        // Change state of GameMachine to continue asking questions.
                let newState = GameState(gameStatus: .answeringQuestion,
                                         teams: self.gameState.teams,
                                         currentQuestion: self.gameState.currentQuestion,
                                         indexOfChoosingTeam: currentChoosingTeamIndex,
                                         indexOfAnsweringTeam: nextTeamAnsweringIndex)
                self.gameState = newState
                return
            }
            
        }

    }
    
}
