//
//  Team.swift
//  Jeopardy
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

struct Team {
    let name : String 
    var score: Int = 0
    
    mutating func changeScore(scor: Int)
    {
        self.score = scor
    }
}
