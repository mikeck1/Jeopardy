//
//  GameState.swift
//  Jeopardy
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

struct GameState {
    private (set) var gameStatus: GameStatus = .notStarted
    private(set) var teams:[Team] = [] 
    private(set) var currentQuestion: QuestionPath?
    private(set) var indexOfChoosingTeam: Int = 0
    private(set) var indexOfAnsweringTeam: Int = 0 
}
