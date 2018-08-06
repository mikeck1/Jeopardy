//
//  QuestionRetriever.swift
//  Jeopardy
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

/*
 Question data is in the QuestionData.plist file in the following format.
 
 Root is an NSDictionary. All data is in the key "categories" as an array.
 
 Each item in the array is an NSDictionary:
 - key "category" has the category name
 - key "questionsInCategory" has an array of questions.
 
 Each question in the array is an NSDictionary
 - key "text" has the question text as a String
 - key "pointValue" has the points value as an Int
 - key "maxTime" has the max time for a question as an Int
 */

class QuestionRetriever {
    
    private(set) var categories: [String] = []
    private var questions: [[Question]] = []
    private var questionsRemaining : Int = 0
    
    init(path: String) {
        
        let rootDictionary = NSDictionary(contentsOfFile: path)         // Get the root of Dictionary
        guard let root = rootDictionary else { return }                 // Get all data from categories as a dictionary
        guard let data = root["categories"] as? [NSDictionary] else { return }
        
        for categoryDictItem in data {
            //Get categories for each dict
            let categoryString : String = categoryDictItem["category"] as! String // Get Category Name
            self.categories.append(categoryString)                      // Append a new Category
            
                                                                        //Get all questions for each dict
            let questionsArrayForEachCategoryDict : [NSDictionary] = categoryDictItem["questionsInCategory"] as! [NSDictionary]
            var tempQuestionsPerCategory : [Question] = []              // Fill all questions into tempQuestionsPerCategory array
            
            for item in questionsArrayForEachCategoryDict               // For each category questions, get parameters
            {
                let tempText        : String = item["text"] as! String  // Get The question text or body
                let maxTime         : Int = item["maxTime"] as! Int     // Get the maxTime
                let pointValue      : Int = item["pointValue"] as! Int  // Get the pointValue
                                                                        // Build a Question
                let tempQuestion    : Question = Question(text: tempText, maxTime: maxTime, category: categoryString, pointValue: pointValue, hasBeenAsked: false)
                questionsRemaining = questionsRemaining + 1             // Increment questionsRemaining becsause we're asking questions
               tempQuestionsPerCategory.append(tempQuestion)            // Append a question to the array of tempQuestionsPerCategory
            }
            
            self.questions.append(tempQuestionsPerCategory)             // Add the array of all questions per category to questions array
        }
//        print(self.categories)    // - For testing
        // Load categories and questions from rootDictionary into self.categories and self.questions
        // Hint, you can get the array of dictionaries inside the root in key "categories" like this:
        // guard let data = root["categories"] as? [NSDictionary] else { return }
    }
    
    
    // This function returns the question for the specified category, at the specified index in that category.
    
    func questionAt(questionPath: QuestionPath) -> Question {           // Get Question At function
        
        // For a categoryIndex and indexInCategory in QuestionPath find a Question
        let tempQuestion : Question = self.questions[questionPath.categoryIndex][questionPath.indexInCategory]
        
        return tempQuestion                                             // Returns the Current Question with respect to categoryIndex and indexInCategory
    }
    
    
    // Set hasBeenAsked as true for the question with specified category, at specified index.
    
    func markQuestionAsAsked(questionPath: QuestionPath) {              // Marks a Question as Has Been Asked (No Longer Asked due to QuestionsRemaining)
                                                                        // For a categoryIndex and indexInCategory, mark a Question As Asked.
                                                                        // Check if question has already been asked.
        if (self.questions[questionPath.categoryIndex][questionPath.indexInCategory].hasBeenAsked == false)
        {
                                                                        // Set question to has been asked. Also decrement the questions remaining variable.
            self.questions[questionPath.categoryIndex][questionPath.indexInCategory].hasBeenAsked = true
            questionsRemaining = questionsRemaining - 1                 // Decrement questionsRemaining since it has been asked.
        }
    }
    
    // Returns the number of questions remaining.
    
    func getQuestionsRemaining() -> Int {

        return questionsRemaining                                       // Accessor for the number of integers remaining.
    }
}
