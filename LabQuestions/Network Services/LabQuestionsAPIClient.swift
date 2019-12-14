//
//  LabQuestionsAPIClient.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct LabQuestionsAPIClient {
  
  static func fetchQuestions(completion: @escaping (Result<[Question],AppError>) -> ()) {
    
    let labEndpointURLString = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
    
    // create a URL from the endpoint String
    guard let url = URL(string: labEndpointURLString) else {
      completion(.failure(.badURL(labEndpointURLString)))
      return
    }
    
    
    // make a URLRequest object to pass to the NetworkHelper
    let request = URLRequest(url: url)
    
    // set the HTTP method, e.g GET, POST, DELETE, PUT, UPDATE, .....
    //request.httpMethod = "POST"
    //request.httpBody = data
    
    // this is required when posting so we inform the POST request
    // of the data type
    // if we do not proveid the header value as "application/json"
    // we will get a decoding error when attempting to decode the JSON
    //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    NetworkHelper.shared.performDataTask(with: request) { (result) in
      switch result {
      case .failure(let appError):
        completion(.failure(.networkClientError(appError)))
      case .success(let data):
        // construct our [Question] array
        do {
          // JSONDecoder() - used to convert web data to Swift models
          // JSONEncoder() - used to convert Swift model to data
          let questions = try JSONDecoder().decode([Question].self, from: data)
          completion(.success(questions))
        } catch {
          completion(.failure(.decodingError(error)))
        }
      }
    }
  }
  
  static func postQuestion(question: PostedQuestion, completion: @escaping (Result<Bool,AppError>) -> ()) {
    
    let endpointURLString = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
    
    // create a url
    guard let url = URL(string: endpointURLString) else {
      completion(.failure(.badURL(endpointURLString)))
      return
    }
    
    // convert PostedQuestion to Data
    do {
      let data = try JSONEncoder().encode(question)
      
      // configure our URLRequest
      // url
      var request = URLRequest(url: url)
      
      // type of http method
      request.httpMethod = "POST"
      
      // type of data
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      
      // provide data being sent to web api
      request.httpBody = data
      
      // execute POST request
      // either our completion captures Data or an AppError
      NetworkHelper.shared.performDataTask(with: request) { (result) in
        switch result {
        case .failure(let appError):
          completion(.failure(.networkClientError(appError)))
        case .success:
          completion(.success(true))
        }
      }
      
    } catch {
      completion(.failure(.encodingError(error)))
    }
    
  }
  
  
}
