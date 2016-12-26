//
//  ComplicationItem.swift
//  WaniTokei
//
//  Created by Andriy K. on 9/6/16.
//  Copyright © 2016 haawa. All rights reserved.
//

import Foundation

public struct ComplicationItem {
  
  public var text: String
  public var shortText: String?
  public var date: Date
  public var color: UIColor
  public var type: Int
  
  public init(text: String, shortText: String?, date: Date, color: UIColor, type: Int) {
    self.text = text
    self.shortText = shortText
    self.date = date
    self.color = color
    self.type = type
  }
  
}
