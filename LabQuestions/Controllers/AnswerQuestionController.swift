//
//  AnswerQuestionController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/16/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class AnswerQuestionController: UIViewController {
  
  @IBOutlet weak var answerTextView: UITextView!
  
  var question: Question?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @IBAction func postAnswer(_ sender: UIBarButtonItem) {
    guard let answerText = answerTextView.text,
      !answerText.isEmpty,
      let question = question else {
      showAlert(title: "Missing Fields", message: "Answer is required, fellow is waiting...")
      return
    }
    
    // create a PostedAnswer instance
    let postedAnswer = PostedAnswer(questionTitle: question.title, questionId: question.id, questionLabName: question.labName, answerDescription: answerText, createdAt: String.getISOTimestamp())
    
  }
  
  
}
