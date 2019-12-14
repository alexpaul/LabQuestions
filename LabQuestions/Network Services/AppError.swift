//
//  AppError.swift
//  AstronomyPhotos
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

enum AppError: Error, CustomStringConvertible {
  case badURL(String) // associated value
  case noResponse
  case networkClientError(Error) // no internet connection
  case noData
  case decodingError(Error)
  case encodingError(Error)
  case badStatusCode(Int) // 404, 500
  case badMimeType(String) // image/jpg
  
  // TODO: handle more descriptive language for
  // error cases
  var description: String {
    switch self {
    case .decodingError(let error):
      return "\(error)"
    case .badStatusCode(let code):
      return "\(code)"
    case .encodingError(let error):
      return "encoding error: \(error)"
    case .networkClientError(let error):
      return "network error: \(error)"
    case .badURL(let url):
      return "Verify the url \(url)"
    default:
      return "other appError \(self)"
    }
  }
}
