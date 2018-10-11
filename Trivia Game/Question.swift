//
//  Question.swift
//  Trivia Game
//
//  Created by Solomon Keiffer on 10/9/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.
//

import Foundation

class Question: NSObject, NSCoding {
    var question: String
    var answers: [String]
    var correctAnswer: Int
    
    init(Question: String, Answers: [String], CorrectAnswer: Int) {
        question = Question
        answers = Answers
        correctAnswer = CorrectAnswer
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let q = aDecoder.decodeObject(forKey: "question") as! String
        let a = aDecoder.decodeObject(forKey: "answers") as! [String]
        let c = aDecoder.decodeInteger(forKey: "correctAnswer")
        self.init(Question: q, Answers: a, CorrectAnswer: c)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(question , forKey: "question")
        aCoder.encode(answers , forKey: "answers")
        aCoder.encode(correctAnswer , forKey: "correctAnswer")
    }
    
    static func saveArray(questions: [Question]) {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: questions), forKey: "questions")
    }
    
    static func loadArray() -> [Question]? {
        guard let questionData = UserDefaults.standard.value(forKey: "questions") else {
            return nil
        }
        let questions = NSKeyedUnarchiver.unarchiveObject(with: questionData as! Data)
        return questions as! [Question]
    }
}
