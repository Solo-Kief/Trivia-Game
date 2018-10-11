//  ViewController.swift
//  Trivia Game
//
//  Created by Solomon Kieffer on 10/8/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.

import UIKit

class ViewController: UIViewController {
    @IBOutlet var questionField: UITextView!
    @IBOutlet var questionFieldHeight: NSLayoutConstraint!
    @IBOutlet var answer1: UIButton!
    @IBOutlet var answer2: UIButton!
    @IBOutlet var answer3: UIButton!
    @IBOutlet var answer4: UIButton!
    
    
    static var questions: [Question] = []
    var correctAnswer = 0
    var defaultColor = UIColor()
    var lastQuestion = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultColor = answer1.backgroundColor!
        
        guard let loadedQuestions = Question.loadArray() else {
            buildDefaultQuestions()
            Question.saveArray(questions: ViewController.questions)
            loadQuestion()
            return
        }
        ViewController.questions = loadedQuestions
        
        if ViewController.questions.count == 0 { //temporary for testing.
            buildDefaultQuestions()
        }
        
        loadQuestion()
    }

    func loadQuestion() {
        var selector = Int.random(in: 0..<ViewController.questions.count)
        while lastQuestion == selector && ViewController.questions.count != 1 {
            selector = Int.random(in: 0..<ViewController.questions.count)
        } //Prevents a question from repeating back-to-back.
        lastQuestion = selector
        
        questionField.text = ViewController.questions[selector].question
        answer1.setTitle(ViewController.questions[selector].answers[0], for: .normal)
        answer2.setTitle(ViewController.questions[selector].answers[1], for: .normal)
        answer3.setTitle(ViewController.questions[selector].answers[2], for: .normal)
        answer4.setTitle(ViewController.questions[selector].answers[3], for: .normal)
        correctAnswer = ViewController.questions[selector].correctAnswer
        
        UIView.animate(withDuration: 0.25, animations: {
            self.questionField.backgroundColor = UIColor.clear
            self.questionField.textColor = UIColor.clear
        })
        let time = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(updateTextViewConstraint), userInfo: nil, repeats: false)
        time.fireDate = Date().addingTimeInterval(0.35)
    }
    
    func buildDefaultQuestions() { //temporary function for testing.
        ViewController.questions.append(Question(Question: "How many buttons are on an iPhone X?", Answers: ["One", "Two", "Three", "Four"], CorrectAnswer: 3))
        ViewController.questions.append(Question(Question: "But what of the poor gator?", Answers: ["Forever More", "Forever Blank", "Forever Great", "Fourever Pun"], CorrectAnswer: 2))
        ViewController.questions.append(Question(Question: "Babe Ruth is assosiated with which sport?", Answers: ["Football", "Basketball", "Baseball", "Soccer"], CorrectAnswer: 3))
        ViewController.questions.append(Question(Question: "What's the total number of dots on a pair of dice?", Answers: ["36", "32", "12", "42"], CorrectAnswer: 4))
        ViewController.questions.append(Question(Question: "What planet is the closest to earth?", Answers: ["Venus", "Pluto", "Mars", "Neptune"], CorrectAnswer: 1))
        ViewController.questions.append(Question(Question: "What is the tallest Mammal?", Answers: ["Elephant", "Human", "Giraffe", "Kangaroo"], CorrectAnswer: 3))
        ViewController.questions.append(Question(Question: "How many strings does a violin have?", Answers: ["Three", "Four", "Five", "Six"], CorrectAnswer: 2))
        ViewController.questions.append(Question(Question: "What is the chemical symbol for hydrogen?", Answers: ["Hy", "Hn", "HyGn", "H"], CorrectAnswer: 4))
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        answer1.isUserInteractionEnabled = false
        answer2.isUserInteractionEnabled = false
        answer3.isUserInteractionEnabled = false
        answer4.isUserInteractionEnabled = false
        
        switch sender {
        case answer1:
            if correctAnswer == 1 {
                changeColor(button: 1, color: UIColor.green)
            } else {
                changeColor(button: 1, color: UIColor.red)
            }
        case answer2:
            if correctAnswer == 2 {
                changeColor(button: 2, color: UIColor.green)
            } else {
                changeColor(button: 2, color: UIColor.red)
            }
        case answer3:
            if correctAnswer == 3 {
                changeColor(button: 3, color: UIColor.green)
            } else {
                changeColor(button: 3, color: UIColor.red)
            }
        case answer4:
            if correctAnswer == 4 {
                changeColor(button: 4, color: UIColor.green)
            } else {
                changeColor(button: 4, color: UIColor.red)
            }
        default:
            return
        }
        
        let time = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(resetScenario), userInfo: nil, repeats: false)
        time.fireDate = Date().addingTimeInterval(1.25)
    }
    
    func changeColor(button: Int, color: UIColor) {
        switch button {
        case 1:
            UIView.animate(withDuration: 0.25, animations: {self.answer1.backgroundColor = color})
        case 2:
            UIView.animate(withDuration: 0.25, animations: {self.answer2.backgroundColor = color})
        case 3:
            UIView.animate(withDuration: 0.25, animations: {self.answer3.backgroundColor = color})
        case 4:
            UIView.animate(withDuration: 0.25, animations: {self.answer4.backgroundColor = color})
        default:
            return
        }
    }
    
    @objc func updateTextViewConstraint() { //View did load helper.
        questionFieldHeight.constant = CGFloat(20 * Double(Double(self.questionField.text.count) / 50).rounded(.up) + 10)
        if questionFieldHeight.constant == 30 {
            questionField.layer.cornerRadius = 15
        } else {
            questionField.layer.cornerRadius = 20
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.questionField.backgroundColor = UIColor.lightGray
            self.questionField.textColor = UIColor.black
        })
    }
    
    @objc func resetScenario() {
        UIView.animate(withDuration: 0.25, animations: {self.answer1.backgroundColor = self.defaultColor})
        UIView.animate(withDuration: 0.25, animations: {self.answer2.backgroundColor = self.defaultColor})
        UIView.animate(withDuration: 0.25, animations: {self.answer3.backgroundColor = self.defaultColor})
        UIView.animate(withDuration: 0.25, animations: {self.answer4.backgroundColor = self.defaultColor})
        
        answer1.isUserInteractionEnabled = true
        answer2.isUserInteractionEnabled = true
        answer3.isUserInteractionEnabled = true
        answer4.isUserInteractionEnabled = true
        
        loadQuestion()
    }
}
