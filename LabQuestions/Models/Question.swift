//
//  Question.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct Question: Decodable {
  let id: String
  let createdAt: String // creating a date stamp
  let name: String // random user name
  let avatar: String // random user avatar
  let title: String
  let description: String
  let labName: String
}
