//
//  GameMachineAnsweringTests.swift
//  JeopardyTests
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import XCTest

class GameMachineAnsweringTests: XCTestCase {
    var qr: QuestionRetriever!
    var teams:[Team] = [Team(name: "Team1", score: 0),
                        Team(name: "Team2", score: 0),
                        Team(name: "Team3", score: 0)]

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let testBundle = Bundle(for: GameMachineAnsweringTests.self)
        let path = testBundle.path(forResource: "TestQuestionData", ofType: "plist")
        self.qr = QuestionRetriever(path: path!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAnswerCorrectly() {
        let gameState = GameState(gameStatus: .answeringQuestion,
                                  teams: self.teams,
                                  currentQuestion: QuestionPath(categoryIndex: 0, indexInCategory: 0),
                                  indexOfChoosingTeam: 1,
                                  indexOfAnsweringTeam: 1)
        let gm = GameMachine(qr: self.qr, gameState: gameState)
        gm.answeredQuestion(withCorrectAnswer: true)
        
        XCTAssertEqual(gm.gameState.gameStatus, .choosingQuestion)
        XCTAssertEqual(gm.gameState.indexOfChoosingTeam, 2)
        XCTAssertNil(gm.gameState.currentQuestion)

        XCTAssertEqual(gm.gameState.teams[0].score, 0)
        XCTAssertEqual(gm.gameState.teams[1].score, 100)
        XCTAssertEqual(gm.gameState.teams[2].score, 0)
    }

    func testAnswerCorrectlyNotChoosingTeam() {
        let gameState = GameState(gameStatus: .answeringQuestion,
                                  teams: self.teams,
                                  currentQuestion: QuestionPath(categoryIndex: 0, indexInCategory: 0),
                                  indexOfChoosingTeam: 1,
                                  indexOfAnsweringTeam: 0)
        let gm = GameMachine(qr: self.qr, gameState: gameState)
        gm.answeredQuestion(withCorrectAnswer: true)
        
        XCTAssertEqual(gm.gameState.gameStatus, .choosingQuestion)
        XCTAssertEqual(gm.gameState.indexOfChoosingTeam, 2)
        XCTAssertNil(gm.gameState.currentQuestion)

        XCTAssertEqual(gm.gameState.teams[0].score, 100)
        XCTAssertEqual(gm.gameState.teams[1].score, 0)
        XCTAssertEqual(gm.gameState.teams[2].score, 0)
    }

    func testAnswerIncorrectly() {
        let gameState = GameState(gameStatus: .answeringQuestion,
                                  teams: self.teams,
                                  currentQuestion: QuestionPath(categoryIndex: 0, indexInCategory: 0),
                                  indexOfChoosingTeam: 1,
                                  indexOfAnsweringTeam: 1)
        let gm = GameMachine(qr: self.qr, gameState: gameState)
        gm.answeredQuestion(withCorrectAnswer: false)
        
        XCTAssertEqual(gm.gameState.gameStatus, .answeringQuestion)
        XCTAssertEqual(gm.gameState.indexOfAnsweringTeam, 2)
        XCTAssertEqual(gm.gameState.teams[0].score, 0)
        XCTAssertEqual(gm.gameState.teams[1].score, 0)
        XCTAssertEqual(gm.gameState.teams[2].score, 0)
        
        gm.answeredQuestion(withCorrectAnswer: false)
        XCTAssertEqual(gm.gameState.gameStatus, .answeringQuestion)
        XCTAssertEqual(gm.gameState.indexOfAnsweringTeam, 0)
        XCTAssertEqual(gm.gameState.teams[0].score, 0)
        XCTAssertEqual(gm.gameState.teams[1].score, 0)
        XCTAssertEqual(gm.gameState.teams[2].score, 0)
    }
    
    func testAnswerAllIncorrect() {
        let gameState = GameState(gameStatus: .answeringQuestion,
                                  teams: self.teams,
                                  currentQuestion: QuestionPath(categoryIndex: 0, indexInCategory: 0),
                                  indexOfChoosingTeam: 1,
                                  indexOfAnsweringTeam: 1)
        let gm = GameMachine(qr: self.qr, gameState: gameState)
        gm.answeredQuestion(withCorrectAnswer: false)
        gm.answeredQuestion(withCorrectAnswer: false)
        gm.answeredQuestion(withCorrectAnswer: false)

        XCTAssertEqual(gm.gameState.gameStatus, .choosingQuestion)
        XCTAssertEqual(gm.gameState.indexOfChoosingTeam, 2)
        
        XCTAssertEqual(gm.gameState.teams[0].score, 0)
        XCTAssertEqual(gm.gameState.teams[1].score, 0)
        XCTAssertEqual(gm.gameState.teams[2].score, 0)
    }
    
    func testAnsweredAllQuestions() {
        let gameState = GameState(gameStatus: .choosingQuestion,
                                  teams: self.teams,
                                  currentQuestion: nil,
                                  indexOfChoosingTeam: 0,
                                  indexOfAnsweringTeam: 0)
        
        let gm = GameMachine(qr: self.qr, gameState: gameState)
        
        gm.chooseQuestion(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        gm.answeredQuestion(withCorrectAnswer: true)
        
        gm.chooseQuestion(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 1))
        gm.answeredQuestion(withCorrectAnswer: true)

        gm.chooseQuestion(questionPath: QuestionPath(categoryIndex: 1, indexInCategory: 0))
        gm.answeredQuestion(withCorrectAnswer: true)

        gm.chooseQuestion(questionPath: QuestionPath(categoryIndex: 1, indexInCategory: 1))
        gm.answeredQuestion(withCorrectAnswer: true)

        XCTAssertEqual(gm.gameState.gameStatus, .gameOver)
        XCTAssertEqual(gm.gameState.teams[0].score, 300)
        XCTAssertEqual(gm.gameState.teams[1].score, 200)
        XCTAssertEqual(gm.gameState.teams[2].score, 100)
    }
}
