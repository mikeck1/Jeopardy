//
//  GameMachineChoosingQuestionTests.swift
//  JeopardyTests
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import XCTest

class GameMachineChoosingQuestionTests: XCTestCase {
    var qr: QuestionRetriever!
    var teams:[Team] = [Team(name: "Team1", score: 0),
                        Team(name: "Team2", score: 0),
                        Team(name: "Team3", score: 0)]

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let testBundle = Bundle(for: GameMachineNotStartedTests.self)
        let path = testBundle.path(forResource: "TestQuestionData", ofType: "plist")
        self.qr = QuestionRetriever(path: path!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testChooseQuestion() {
        let gameState = GameState(gameStatus: .choosingQuestion,
                                  teams: self.teams,
                                  currentQuestion: nil,
                                  indexOfChoosingTeam: 1,
                                  indexOfAnsweringTeam: 0)
        let gm = GameMachine(qr: self.qr, gameState: gameState)
        gm.chooseQuestion(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        
        XCTAssertEqual(gm.gameState.gameStatus, .answeringQuestion)
        XCTAssertEqual(gm.gameState.indexOfAnsweringTeam, 1)
        XCTAssertEqual(gm.gameState.currentQuestion?.categoryIndex, 0)
        XCTAssertEqual(gm.gameState.currentQuestion?.indexInCategory, 0)
        
        // scores unchanged
        XCTAssertEqual(gm.gameState.teams[0].score, 0)
        XCTAssertEqual(gm.gameState.teams[1].score, 0)
        XCTAssertEqual(gm.gameState.teams[2].score, 0)
    }
    
    func testChooseQuestionAlreadyAsked() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let gameState = GameState(gameStatus: .choosingQuestion,
                                  teams: self.teams,
                                  currentQuestion: nil,
                                  indexOfChoosingTeam: 1,
                                  indexOfAnsweringTeam: 0)
        
        //question was answered correctly
        qr.markQuestionAsAsked(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        
        //get gm
        let gm = GameMachine(qr: self.qr, gameState: gameState)
        
        //get  gm particular question[0][0]
        gm.chooseQuestion(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        
        XCTAssertEqual(gm.gameState.gameStatus, .choosingQuestion, "stays in choosing question")
        XCTAssertEqual(gm.gameState.indexOfChoosingTeam, 1, "indexOfChoosingTeam unchanged")
        XCTAssertEqual(gm.gameState.indexOfAnsweringTeam, 0, "indexOfAnsweringTeam remains 0")
        XCTAssertNil(gm.gameState.currentQuestion)
        
        // scores unchanged
        XCTAssertEqual(gm.gameState.teams[0].score, 0)
        XCTAssertEqual(gm.gameState.teams[1].score, 0)
        XCTAssertEqual(gm.gameState.teams[2].score, 0)
    }
}
