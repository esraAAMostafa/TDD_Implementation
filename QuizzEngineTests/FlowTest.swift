//
//  FlowTest.swift
//  QuizzEngineTests
//
//  Created by Esraa on 6/1/20.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizzEngine

class FlowTest: XCTestCase {

    let router = RouterSpy()

    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSTU(questions: []).start()
        
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }

    func test_start_withOneQuestion_routeToCorrectQuestion() {
        makeSTU(questions: ["Q1"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestion_routeToCorrectQuestion_2() {
        makeSTU(questions: ["Q2"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routeToFirstQuestion() {
        makeSTU(questions: ["Q1", "Q2"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routeToFirstQuestionTwice() {
        let sut = makeSTU(questions: ["Q1", "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }

    func test_startAndAnswerFirstAndSecoundQuestion_withThreeQuestions_routeToSecoundAndThirdQuestion() {
        let sut = makeSTU(questions: ["Q1", "Q2", "Q3"])
        
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToAnotherQuestion() {
        let sut = makeSTU(questions: ["Q1"])
        
        sut.start()
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_routeToResult() {
        makeSTU(questions: []).start()
        
        XCTAssertEqual(router.routedResults!, [:])
    }
    
    func test_start_withOneQuestions_doesNotRouteToResult() {
        makeSTU(questions: ["Q1"]).start()

        XCTAssertNil(router.routedResults)
    }

    func test_startAndAnswerFirstQuestion_withTwoQuestion_doesNotRouteToResults() {
        let sut = makeSTU(questions: ["Q1", "Q2"])
        
        sut.start()
        router.answerCallback("A1")
    
        XCTAssertNil(router.routedResults)
    }

    func test_startAndAnswerFirstAndSecoundQuestion_withTwoQuestion_routeToResults() {
        let sut = makeSTU(questions: ["Q1", "Q2"])
        
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedResults!, ["Q1": "A1", "Q2": "A2"])
    }

    //MARK: Helpers
    
    func makeSTU(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var routedResults: [String: String]? = nil
        var answerCallback: Router.AnswerCallback = { _ in }

        func routeTo(question: String, answerCallback: @escaping Router.AnswerCallback) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(results: [String: String]) {
            routedResults = results
        }
    }
}
