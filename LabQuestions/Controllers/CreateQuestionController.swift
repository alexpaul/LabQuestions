//
//  CreateQuestionController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class CreateQuestionController: UIViewController {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var questionTextView: UITextView!
  @IBOutlet weak var labPickerView: UIPickerView!
  
  // data for our picker view
   private let labs = ["Concurrency", "Comic", "Parsing JSON - Weather, Color, User", "Image and Error Handling",
                      "StocksPeople", "Intro to Unit testing - Jokes, Star Wars, Trivia", "Text-based adventure",
                      "Hangman CLI", "Calculator CLI", "Three Card Monte", "ColorGuessingGame", "TextTwist","Autolayout-Lab",
                      "CardGenerator", "TableView-Sections-Lab", "ZooAnimals", "Game of Thrones", "UpdatingFont", "GroceryList",
                      "Tic Tac Toe", "Hangman iOS app", "Making GET requests - Shows, Episodes"].sorted() // ascending by default a - z
  
  // labName will be the current selected row in the picker view
  private var labName: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // configure the picker view
    labPickerView.dataSource = self
    labPickerView.delegate = self
    
    // variable to track the current selected lab in the picker view
    labName = labs.first // default lab is the first row in the picker view
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    // we want to change the color and border width of
    // the text view
    // experiment with shadows on views
    // every view has a CALayer - CA Core Animation
    
    // semantic colors are new to iOS 13
    // semantic colors adapt to light or dark mode
    // CG - Core Graphics
    questionTextView.layer.borderColor = UIColor.systemGray.cgColor
    questionTextView.layer.borderWidth = 1
  }
  
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @IBAction func createQuestion(_ sender: UIBarButtonItem) {
    // 3 required paramerters to create a PostedQuestion
    
    // disable the create bar button so multiple requests won't occur
    sender.isEnabled = false
    
    guard let questionTitle = titleTextField.text,
      !questionTitle.isEmpty,
      let labName = labName,
      let labDescription = questionTextView.text,
      !labDescription.isEmpty else {
        showAlert(title: "Missing Fields", message: "Title, Description are required")
        sender.isEnabled = true
        return
    }
    
    let question = PostedQuestion(title: questionTitle,
                                  labName: labName,
                                  description: labDescription, createdAt: String.getISOTimestamp())
    
    // POST question using APIClient
    LabQuestionsAPIClient.postQuestion(question: question) { [weak self, weak sender] (result) in
      DispatchQueue.main.async {
        sender?.isEnabled = true
      }
      switch result {
      case .failure(let appError):
        DispatchQueue.main.async {
          self?.showAlert(title: "Error posting question", message: "\(appError)")
        }
      case .success:
        DispatchQueue.main.async {
          self?.showAlert(title: "Success", message: "\(questionTitle) was posted") { action in
            self?.dismiss(animated: true)
          }
        }
      }
    }
  }
  
  
}

extension CreateQuestionController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return labs.count
  }
}

extension CreateQuestionController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return labs[row]
  }
}
