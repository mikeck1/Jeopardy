//
//  GameMachineNotStartedTests.swift
//  JeopardyTests
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import XCTest

class GameMachineNotStartedTests: XCTestCase {
    
    var gm: GameMachine!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let testBundle = Bundle(for: GameMachineNotStartedTests.self)
        let path = testBundle.path(forResource: "TestQuestionData", ofType: "plist")
        self.gm = GameMachine(path: path!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialState() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertEqual(gm.gameState.gameStatus, GameStatus.notStarted)
        XCTAssertNil(gm.gameState.currentQuestion)
        XCTAssertEqual(gm.gameState.indexOfAnsweringTeam, 0)
        XCTAssertEqual(gm.gameState.indexOfAnsweringTeam, 0)
        XCTAssertEqual(gm.gameState.teams.count, 0)
    }

    func testAddTeam() {
        gm.addTeam(name: "Team1")
        
        XCTAssertEqual(gm.gameState.gameStatus, GameStatus.notStarted)
        XCTAssertEqual(gm.gameState.teams[0].name, "Team1")
        XCTAssertEqual(gm.gameState.teams[0].score, 0)
    }

    func testStartGameWithoutTeams() {
        gm.startGame()
        
        XCTAssertEqual(gm.gameState.gameStatus, GameStatus.notStarted)
    }
    
    func testStartGameWithOneTeam() {
        gm.addTeam(name: "Team1")
        gm.startGame()

        XCTAssertEqual(gm.gameState.gameStatus, GameStatus.notStarted)
    }
    
    func testStartGameWithSufficientTeams() {
        gm.addTeam(name: "Team1")
        gm.addTeam(name: "Team2")
        gm.startGame()
        
        XCTAssertEqual(gm.gameState.gameStatus, GameStatus.choosingQuestion)
        XCTAssertEqual(gm.gameState.indexOfChoosingTeam, 0)
    }
}
