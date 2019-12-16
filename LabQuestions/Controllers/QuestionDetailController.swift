//
//  QuestionDetailController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class QuestionDetailController: UIViewController {
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var labNameLabel: UILabel!
  @IBOutlet weak var questionTextView: UITextView!
  
  var question: Question?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let navController = segue.destination as? UINavigationController,
      let answerQuestionController = navController.viewControllers.first as? AnswerQuestionController else {
      fatalError("could not downcast to AnswerQuestionController")
    }
    answerQuestionController.question = question
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
  }
  
  private func updateUI() {
    guard let question = question else {
      fatalError("could not update ui, verify question got set in prepare(for segue: )")
    }
    labNameLabel.text = question.labName
    questionTextView.text = question.description
    userImageView.getImage(with: question.avatar) { [weak self] (result) in
      switch result {
      case .failure:
        // because getImage is using NetworkHelper which uses URLSession and is on
        // a background thread. We are not allowed to updated UI on a background thread
        // the app will crash as a result.
        DispatchQueue.main.async {
          self?.userImageView.image = UIImage(systemName: "person.fill")
        }
      case .success(let image):
        DispatchQueue.main.async {
          self?.userImageView.image = image
        }
      }
    }
  }
  
  
}
