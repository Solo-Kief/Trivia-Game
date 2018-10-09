//
//  ViewController.swift
//  Trivia Game
//
//  Created by Solomon Keiffer on 10/8/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var questionField: UITextField!
    @IBOutlet var answer1: UIButton!
    @IBOutlet var answer2: UIButton!
    @IBOutlet var answer3: UIButton!
    @IBOutlet var answer4: UIButton!
    
    var questions: [Question] = []
    var correctAnswer = 0
    var defaultColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultColor = answer1.backgroundColor!
        
        buildQuestions()
        loadQuestion()
    }

    func loadQuestion() {
        let selector = Int.random(in: 0..<questions.count)
        
        questionField.text = questions[selector].question
        answer1.setTitle(questions[selector].answers[0], for: .normal)
        answer2.setTitle(questions[selector].answers[1], for: .normal)
        answer3.setTitle(questions[selector].answers[2], for: .normal)
        answer4.setTitle(questions[selector].answers[3], for: .normal)
        correctAnswer = questions[selector].correctAnswer
    }
    
    func buildQuestions() {
        questions.append(Question(Question: "How many buttons are on an iPhone X?", Answers: ["One", "Two", "Three", "Four"], CorrectAnswer: 3))
        questions.append(Question(Question: "But what of the small gator?", Answers: ["Forever More", "Forever Blank", "Forever Great", "Fourever Pun"], CorrectAnswer: 2))
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
        
        let time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(resetScenario), userInfo: nil, repeats: false)
        time.fireDate = Date().addingTimeInterval(2)
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
