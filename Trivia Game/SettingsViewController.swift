//  SettingsViewController.swift
//  Trivia Game
//
//  Created by Solomon Kieffer on 10/9/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var questionPicker: UIPickerView!
    @IBOutlet var questionField: UITextField!
    @IBOutlet var answerField1: UITextField!
    @IBOutlet var answerField2: UITextField!
    @IBOutlet var answerField3: UITextField!
    @IBOutlet var answerField4: UITextField!
    @IBOutlet var toggleEditButton: UIButton!
    @IBOutlet var editActionButton: UIButton!
    @IBOutlet var correctAnswerSelector: UISegmentedControl!
    
    var defaultButtonColor = UIColor()
    
    var questionPickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        defaultButtonColor = editActionButton.tintColor
        
        questionPicker.delegate = self
        questionPicker.dataSource = self
        
        for i in 1...ViewController.questions.count {
            questionPickerData.append("Question #\(i)")
        }
        updateText()
    }
    
    //Exclusive to picker
    func rebuildData() {
        questionPickerData = []
        
        guard ViewController.questions.count > 0 else {
            return
        }
        
        for i in 1...ViewController.questions.count {
            questionPickerData.append("Question #\(i)")
        }
    } //Non-Standard function to rebuild the data list.
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    } //Column Count
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return questionPickerData.count
    } //Row Count
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return questionPickerData[row]
    } //Loads in the values for the picker.
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateText()
    } //Allows the text to update when a new row is selected.
    /////////////////////
    
    func updateText() {
        guard ViewController.questions.count != 0 else {
            questionField.text = ""
            answerField1.text = ""
            answerField2.text = ""
            answerField3.text = ""
            answerField4.text = ""
            return
        }
        
        questionField.text = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].question
        answerField1.text = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].answers[0]
        answerField2.text = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].answers[1]
        answerField3.text = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].answers[2]
        answerField4.text = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].answers[3]
    }
    
    @IBAction func toggleEdit(_ sender: UIButton) {
        if toggleEditButton.currentTitle == "Toggle Edit Mode" {
            toggleEditButton.setTitle("End Edit Mode", for: .normal)
            editActionButton.setTitle("Add Question", for: .normal)
            editActionButton.isUserInteractionEnabled = true
            editActionButton.tintColor = defaultButtonColor
            correctAnswerSelector.isHidden = false
            correctAnswerSelector.isUserInteractionEnabled = true
            correctAnswerSelector.selectedSegmentIndex = 0
            questionPicker.isUserInteractionEnabled = false
            questionField.text = ""
            answerField1.text = ""
            answerField2.text = ""
            answerField3.text = ""
            answerField4.text = ""
            answerField1.isUserInteractionEnabled = true
            answerField2.isUserInteractionEnabled = true
            answerField3.isUserInteractionEnabled = true
            answerField4.isUserInteractionEnabled = true
            questionField.isUserInteractionEnabled = true
        } else {
            toggleEditButton.setTitle("Toggle Edit Mode", for: .normal)
            editActionButton.setTitle("Delete Question", for: .normal)
            if ViewController.questions.count == 0 {
                editActionButton.isUserInteractionEnabled = false
                editActionButton.tintColor = UIColor.red
            }
            questionPicker.isUserInteractionEnabled = true
            correctAnswerSelector.isHidden = true
            correctAnswerSelector.isUserInteractionEnabled = false
            answerField1.isUserInteractionEnabled = false
            answerField2.isUserInteractionEnabled = false
            answerField3.isUserInteractionEnabled = false
            answerField4.isUserInteractionEnabled = false
            questionField.isUserInteractionEnabled = false
            updateText()
        }
    }
    
    @IBAction func triggerEditAction(_ sender: UIButton) {
        if editActionButton.currentTitle == "Delete Question" {
            let alert = UIAlertController(title: "Delete Question", message: "Are you sure you want to delete this question?", preferredStyle: .alert)
            
            let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {action in ViewController.questions.remove(at: self.questionPicker.selectedRow(inComponent: 0))
                self.rebuildData()
                self.questionPicker.reloadAllComponents()
                self.questionPicker.selectRow(-1, inComponent: 0, animated: false)
                self.updateText()
                Question.saveArray(questions: ViewController.questions)
                if ViewController.questions.count == 0 {
                    self.editActionButton.isUserInteractionEnabled = false
                    self.editActionButton.tintColor = UIColor.red
                }
            })
            alert.addAction(cancleAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true)
        } else {
            guard questionField.text != "" && answerField1.text != "" && answerField2.text != "" && answerField3.text != "" && answerField4.text != "" else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.editActionButton.setTitle("Fields Must Be Filled", for: .normal)
                    self.editActionButton.backgroundColor = UIColor.red
                })
                editActionButton.isUserInteractionEnabled = false
                let time = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(resetEditActionButton), userInfo: nil, repeats: false)
                time.fireDate = Date().addingTimeInterval(3)
                return
            }
            ViewController.questions.append(Question(Question: questionField.text!, Answers: [answerField1.text!, answerField2.text!, answerField3.text!, answerField4.text!], CorrectAnswer: correctAnswerSelector.selectedSegmentIndex + 1))
            questionField.text = ""
            answerField1.text = ""
            answerField2.text = ""
            answerField3.text = ""
            answerField4.text = ""
            UIView.animate(withDuration: 0.25, animations: {
                self.editActionButton.setTitle("Question Added", for: .normal)
                self.editActionButton.backgroundColor = UIColor.green
            })
            let time = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(resetEditActionButton), userInfo: nil, repeats: false)
            time.fireDate = Date().addingTimeInterval(1.25)
            self.rebuildData()
            self.questionPicker.reloadAllComponents()
            Question.saveArray(questions: ViewController.questions)
        }
        
    }
    
    @objc func resetEditActionButton() { //Partner function for triggerEditAction.
        UIView.animate(withDuration: 0.25, animations: {
            self.editActionButton.setTitle("Add Question", for: .normal)
            self.editActionButton.backgroundColor = UIColor.clear
        })
        editActionButton.isUserInteractionEnabled = true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
