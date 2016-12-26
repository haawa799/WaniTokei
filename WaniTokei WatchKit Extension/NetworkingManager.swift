//
//  NetworkingManager.swift
//  WaniTokei
//
//  Created by Andriy K. on 9/6/16.
//  Copyright © 2016 haawa. All rights reserved.
//

import Foundation
import TokeiModel


struct NetworkingManager {
  
  let apiKey: String
  
  init(apiKey: String) {
    self.apiKey = apiKey
  }
  
  /// Returns items from wanikani.com or nil if fail. Results return on the main thread.
  func sendRequest(handler: @escaping ([Item]?)->()) {
    
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    
    guard let URL = URL(string: "https://www.wanikani.com/api/user/\(apiKey)/critical-items/80") else {return}
    var request = URLRequest(url: URL)
    request.httpMethod = "GET"
    
    /* Start a new Task */
    let task = session.dataTask(with: request) { (data, response, error) in
      if (error == nil) {
        let waniResponse = WaniKaniResponse(data: data)
        guard let resp =  waniResponse?.requestedInfo else { return }
        switch resp {
        case .list(let array):
          DispatchQueue.main.async {
            handler(array)
          }
          
        }
      }
      else {
        // Failure
        print("URL Session Task Failed: %@", error!.localizedDescription);
        DispatchQueue.main.async {
          handler(nil)
        }
      }
    }
    task.resume()
    session.finishTasksAndInvalidate()
  }
  
}
