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
    var questionDidChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        defaultButtonColor = editActionButton.titleColor(for: .normal)!
        
        questionPicker.delegate = self
        questionPicker.dataSource = self
        
        // See textFieldDidChange()
        questionField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        answerField1.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        answerField2.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        answerField3.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        answerField4.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        //
        
        for i in 1...ViewController.questions.count { // Same as rebuildData()
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
            correctAnswerSelector.selectedSegmentIndex = -1
            return
        }
        
        questionField.text = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].question
        answerField1.text = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].answers[0]
        answerField2.text = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].answers[1]
        answerField3.text = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].answers[2]
        answerField4.text = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].answers[3]
        correctAnswerSelector.selectedSegmentIndex = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].correctAnswer - 1
    }
    
    @IBAction func toggleEdit(_ sender: UIButton) { //Variable action depending on button state.
        if toggleEditButton.currentTitle == "Toggle Edit Mode" { //Triggers the app to prep for question editing.
            toggleEditButton.setTitle("End Edit Mode", for: .normal)
            editActionButton.setTitle("Delete Question", for: .normal)
            editActionButton.isUserInteractionEnabled = true
            editActionButton.setTitleColor(defaultButtonColor, for: .normal)
            correctAnswerSelector.isHidden = false
            correctAnswerSelector.isUserInteractionEnabled = true
            correctAnswerSelector.selectedSegmentIndex = ViewController.questions[questionPicker.selectedRow(inComponent: 0)].correctAnswer - 1
            answerField1.isUserInteractionEnabled = true
            answerField2.isUserInteractionEnabled = true
            answerField3.isUserInteractionEnabled = true
            answerField4.isUserInteractionEnabled = true
            questionField.isUserInteractionEnabled = true
            questionField.backgroundColor = UIColor.white
            answerField1.backgroundColor = UIColor.white
            answerField2.backgroundColor = UIColor.white
            answerField3.backgroundColor = UIColor.white
            answerField4.backgroundColor = UIColor.white
        } else if toggleEditButton.currentTitle == "End Edit Mode" { //Ends editing mode.
            if questionDidChange { //Triggers an alert set up if the question was modified. Otherwise, will just perform the else condition.
                let alert = UIAlertController(title: "Edit Question", message: "You have edited the current question. Are you sure you want to save your changes?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
                    self.toggleEditButton.setTitle("Cancel", for: .normal)
                    self.toggleEdit(self.toggleEditButton)
                })
                
                let changeAction = UIAlertAction(title: "Change", style: .default, handler: {action in
                    guard self.questionField.text != "" && self.answerField1.text != "" && self.answerField2.text != "" && self.answerField3.text != "" && self.answerField4.text != "" else {
                        UIView.animate(withDuration: 0.25, animations: {
                            self.editActionButton.setTitle("Fields Must Be Filled", for: .normal)
                            self.editActionButton.backgroundColor = UIColor.red
                        })
                        self.editActionButton.isUserInteractionEnabled = false
                        let time = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.resetEditActionButton2), userInfo: nil, repeats: false)
                        time.fireDate = Date().addingTimeInterval(3)
                        return
                    }
                    ViewController.questions[self.questionPicker.selectedRow(inComponent: 0)].question = self.questionField.text!
                    ViewController.questions[self.questionPicker.selectedRow(inComponent: 0)].answers[0] = self.answerField1.text!
                    ViewController.questions[self.questionPicker.selectedRow(inComponent: 0)].answers[1] = self.answerField2.text!
                    ViewController.questions[self.questionPicker.selectedRow(inComponent: 0)].answers[2] = self.answerField3.text!
                    ViewController.questions[self.questionPicker.selectedRow(inComponent: 0)].answers[3] = self.answerField4.text!
                    ViewController.questions[self.questionPicker.selectedRow(inComponent: 0)].correctAnswer = self.correctAnswerSelector.selectedSegmentIndex + 1
                    
                    Question.saveArray(questions: ViewController.questions)
                    
                    self.questionDidChange = false
                    self.toggleEditButton.setTitle("Cancel", for: .normal)
                    self.toggleEdit(self.toggleEditButton)
                })
                
                alert.addAction(cancelAction)
                alert.addAction(changeAction)
                
                self.present(alert, animated: true)
            } else {
                questionDidChange = false
                toggleEditButton.setTitle("Cancel", for: .normal)
                toggleEdit(toggleEditButton)
            }
        } else { //Resets screen to normal state.
            toggleEditButton.setTitle("Toggle Edit Mode", for: .normal)
            if ViewController.questions.count == 0 {
                toggleEditButton.setTitleColor(UIColor.red, for: .normal)
                toggleEditButton.isUserInteractionEnabled = false
                editActionButton.setTitleColor(defaultButtonColor, for: .normal)
                editActionButton.isUserInteractionEnabled = true
            }
            editActionButton.setTitle("Add Question", for: .normal)
            questionPicker.isUserInteractionEnabled = true
            correctAnswerSelector.isHidden = true
            correctAnswerSelector.isUserInteractionEnabled = false
            answerField1.isUserInteractionEnabled = false
            answerField2.isUserInteractionEnabled = false
            answerField3.isUserInteractionEnabled = false
            answerField4.isUserInteractionEnabled = false
            questionField.isUserInteractionEnabled = false
            questionField.backgroundColor = UIColor.lightGray
            answerField1.backgroundColor = UIColor.lightGray
            answerField2.backgroundColor = UIColor.lightGray
            answerField3.backgroundColor = UIColor.lightGray
            answerField4.backgroundColor = UIColor.lightGray
            updateText()
        }
    }
    
    @IBAction func triggerEditAction(_ sender: UIButton) {
        if editActionButton.currentTitle == "Delete Question" {
            let alert = UIAlertController(title: "Delete Question", message: "Are you sure you want to delete this question?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {action in ViewController.questions.remove(at: self.questionPicker.selectedRow(inComponent: 0))
                self.rebuildData()
                self.questionPicker.reloadAllComponents()
                self.questionPicker.selectRow(-1, inComponent: 0, animated: false)
                self.updateText()
                Question.saveArray(questions: ViewController.questions)
                if ViewController.questions.count == 0 {
                    self.editActionButton.isUserInteractionEnabled = false
                    self.editActionButton.setTitleColor(UIColor.red, for: .normal)
                }
            })
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true)
        } else if editActionButton.currentTitle == "Add Question" {
            questionPicker.isUserInteractionEnabled = false
            questionField.isUserInteractionEnabled = true
            answerField1.isUserInteractionEnabled = true
            answerField2.isUserInteractionEnabled = true
            answerField3.isUserInteractionEnabled = true
            answerField4.isUserInteractionEnabled = true
            questionField.backgroundColor = UIColor.white
            answerField1.backgroundColor = UIColor.white
            answerField2.backgroundColor = UIColor.white
            answerField3.backgroundColor = UIColor.white
            answerField4.backgroundColor = UIColor.white
            if toggleEditButton.titleColor(for: .normal) == UIColor.red {
                toggleEditButton.isUserInteractionEnabled = true
                toggleEditButton.setTitleColor(defaultButtonColor, for: .normal)
            }
            questionField.text = ""
            answerField1.text = ""
            answerField2.text = ""
            answerField3.text = ""
            answerField4.text = ""
            toggleEditButton.setTitle("Cancel", for: .normal)
            editActionButton.setTitle("Confirm Addition", for: .normal)
            correctAnswerSelector.isHidden = false
            correctAnswerSelector.isUserInteractionEnabled = true
            correctAnswerSelector.selectedSegmentIndex = -1
        } else { // Confirm Addition
            guard questionField.text != "" && answerField1.text != "" && answerField2.text != "" && answerField3.text != "" && answerField4.text != "" && correctAnswerSelector.selectedSegmentIndex != -1 else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.editActionButton.setTitle("Fields Must Be Filled", for: .normal)
                    self.editActionButton.backgroundColor = UIColor.red
                    self.editActionButton.setTitleColor(.white, for: .normal)
                })
                editActionButton.isUserInteractionEnabled = false
                let time = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(resetEditActionButton2), userInfo: nil, repeats: false)
                time.fireDate = Date().addingTimeInterval(3)
                return
            }
            ViewController.questions.append(Question(Question: questionField.text!, Answers: [answerField1.text!, answerField2.text!, answerField3.text!, answerField4.text!], CorrectAnswer: correctAnswerSelector.selectedSegmentIndex + 1))
            questionPicker.isUserInteractionEnabled = true
            questionField.isUserInteractionEnabled = false
            answerField1.isUserInteractionEnabled = false
            answerField2.isUserInteractionEnabled = false
            answerField3.isUserInteractionEnabled = false
            answerField4.isUserInteractionEnabled = false
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
        toggleEditButton.setTitle("End Edit Mode", for: .normal)
        toggleEdit(toggleEditButton)
    }
    
    @objc func resetEditActionButton2() { //Alt-Function
        guard toggleEditButton.title(for: .normal) == "Cancel" else {
            if toggleEditButton.title(for: .normal) == "Toggle Edit Mode" {
                UIView.animate(withDuration: 0.25, animations: {
                    self.editActionButton.setTitle("Add Question", for: .normal)
                    self.editActionButton.backgroundColor = UIColor.clear
                    self.editActionButton.setTitleColor(self.defaultButtonColor, for: .normal)
                })
                editActionButton.isUserInteractionEnabled = true
            } else if toggleEditButton.title(for: .normal) == "End Edit Mode" {
                UIView.animate(withDuration: 0.25, animations: {
                    self.editActionButton.backgroundColor = UIColor.clear
                })
            }
            return
        } //Hotfix for button being in wrong state if exiting "add question" state while on the warning animation.
        
        UIView.animate(withDuration: 0.25, animations: {
            self.editActionButton.setTitle("Confirm Addition", for: .normal)
            self.editActionButton.backgroundColor = UIColor.clear
            self.editActionButton.setTitleColor(self.defaultButtonColor, for: .normal)
        })
        editActionButton.isUserInteractionEnabled = true
    }
    
    @objc func textFieldDidChange() { //For whatever reason, valueDidChange does not work on text fields, so we can't use the IBAction to trigger the change. Instead we use some new code in the viewDidLoad function to trigger the change.
        if toggleEditButton.currentTitle == "End Edit Mode" {
            questionDidChange = true
        }
    }
    
    @IBAction func questionChanged() {
        if toggleEditButton.currentTitle == "End Edit Mode" {
            questionDidChange = true
        }
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
