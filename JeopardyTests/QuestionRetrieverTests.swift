//
//  QuestionRetrieverTests.swift
//  JeopardyTests
//
//  Created by Poonam Hattangady on 7/22/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import XCTest

class QuestionRetrieverTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializeCategories() {
        let testBundle = Bundle(for: QuestionRetrieverTests.self)
        let path = testBundle.path(forResource: "TestQuestionData", ofType: "plist")
//        let path = testBundle.path(forResource: "QuestionData", ofType: "plist")
        let qr = QuestionRetriever(path: path!)
        XCTAssertEqual(qr.categories.count, 2)
        
        if (qr.categories.count == 2) {
            XCTAssertEqual(qr.categories[0], "Category0")
            XCTAssertEqual(qr.categories[1], "Category1")
        }
    }
    
    func testInitializeQuestions() {
        let testBundle = Bundle(for: QuestionRetrieverTests.self)
        let path = testBundle.path(forResource: "TestQuestionData", ofType: "plist")
        let qr = QuestionRetriever(path: path!)
        
        let question_00 = qr.questionAt(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        XCTAssertNotNil(question_00, "Question exists")
        testQuestion(question: question_00, category: "Category0", text: "Question0 in Category0", pointValue: 100, maxTime: 60, asked: false)
        
        let question_01 = qr.questionAt(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 1))
        XCTAssertNotNil(question_01, "Question exists")
        testQuestion(question: question_01, category: "Category0", text: "Question1 in Category0", pointValue: 200, maxTime: 120, asked: false)
        
        let question_10 = qr.questionAt(questionPath: QuestionPath(categoryIndex: 1, indexInCategory: 0))
        XCTAssertNotNil(question_10, "Question exists")
        testQuestion(question: question_10, category: "Category1", text: "Question0 in Category1", pointValue: 100, maxTime: 60, asked: false)
        
        let question_11 = qr.questionAt(questionPath: QuestionPath(categoryIndex: 1, indexInCategory: 1))
        XCTAssertNotNil(question_11, "Question exists")
        testQuestion(question: question_11, category: "Category1", text: "Question1 in Category1", pointValue: 200, maxTime: 120, asked: false)
    }
    
    func testMarkAsked() {
        let testBundle = Bundle(for: QuestionRetrieverTests.self)
        let path = testBundle.path(forResource: "TestQuestionData", ofType: "plist")
        let qr = QuestionRetriever(path: path!)
        
        let question_00 = qr.questionAt(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        XCTAssertNotNil(question_00, "Question exists")
        testQuestion(question: question_00, category: "Category0", text: "Question0 in Category0", pointValue: 100, maxTime: 60, asked: false)
        
        qr.markQuestionAsAsked(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        let question_00_again = qr.questionAt(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        testQuestion(question: question_00_again, category: "Category0", text: "Question0 in Category0", pointValue: 100, maxTime: 60, asked: true)
    }
    
    func testQuestionsRemaining() {
        let testBundle = Bundle(for: QuestionRetrieverTests.self)
        let path = testBundle.path(forResource: "TestQuestionData", ofType: "plist")
        let qr = QuestionRetriever(path: path!)
        
        XCTAssertEqual(qr.getQuestionsRemaining(), 4)
        
        qr.markQuestionAsAsked(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        XCTAssertEqual(qr.getQuestionsRemaining(), 3)
        
        qr.markQuestionAsAsked(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 1))
        XCTAssertEqual(qr.getQuestionsRemaining(), 2)
        
        qr.markQuestionAsAsked(questionPath: QuestionPath(categoryIndex: 1, indexInCategory: 0))
        XCTAssertEqual(qr.getQuestionsRemaining(), 1)
        
        qr.markQuestionAsAsked(questionPath: QuestionPath(categoryIndex: 1, indexInCategory: 1))
        XCTAssertEqual(qr.getQuestionsRemaining(), 0)
    }
    
    func testQuestionsRemainingSameQuestionAskedMultipleTimes() {
        let testBundle = Bundle(for: QuestionRetrieverTests.self)
        let path = testBundle.path(forResource: "TestQuestionData", ofType: "plist")
        let qr = QuestionRetriever(path: path!)
        
        XCTAssertEqual(qr.getQuestionsRemaining(), 4)
        
        qr.markQuestionAsAsked(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        qr.markQuestionAsAsked(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        qr.markQuestionAsAsked(questionPath: QuestionPath(categoryIndex: 0, indexInCategory: 0))
        XCTAssertEqual(qr.getQuestionsRemaining(), 3)
        
    }
    
    
    private func testQuestion(question: Question, category: String, text: String, pointValue: Int, maxTime: Int, asked: Bool) {
        XCTAssertEqual(question.text, text)
        XCTAssertEqual(question.category, category)
        XCTAssertEqual(question.maxTime, maxTime)
        XCTAssertEqual(question.pointValue, pointValue)
        XCTAssertEqual(question.hasBeenAsked, asked)
    }
}

