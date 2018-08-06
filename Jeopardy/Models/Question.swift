//
//  Question.swift
//  Jeopardy
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

struct Question {
    let text: String
    let maxTime: Int
    let category: String
    let pointValue: Int
    var hasBeenAsked: Bool = false
}
