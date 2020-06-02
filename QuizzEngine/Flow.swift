//
//  Flow.swift
//  QuizzEngine
//
//  Created by Esraa on 6/1/20.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping AnswerCallback)
    func routeTo(results: [String: String])
}

class Flow {
    private let router: Router
    private let questions: [String]
    private var results: [String: String] = [:]

    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: nextCallBack(from: firstQuestion))
        } else {
            router.routeTo(results: [:])
        }
    }
    
    private func nextCallBack(from question: String) -> Router.AnswerCallback {
        return  { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: String, _ answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            results[question] = answer
            let nextQuestionIndex = currentQuestionIndex+1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallback: nextCallBack(from: nextQuestion))
            } else {
                router.routeTo(results: results)
            }
        }
    }
}
