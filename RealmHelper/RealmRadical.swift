//
//  RealmRadical.swift
//  WaniTokei
//
//  Created by Andriy K. on 9/1/16.
//  Copyright © 2016 haawa. All rights reserved.
//

import Foundation
import RealmSwift
import TokeiModel

public class RealmRadical: RealmReviewItem {
  public dynamic var character: String?
  public dynamic var meaning: String?
  public dynamic var image: String?
  public dynamic var level = 0
  public dynamic var percentage: String?
  public dynamic var userSpecific: RealmUserSpecific?
  
  public override var item: Item? {
    var radical = RadicalInfo(level: level)
    radical.character = character
    radical.meaning = meaning
    radical.image = image
    radical.percentage = percentage
    radical.userSpecific = userSpecific?.userSpecific
    return Item.radical(radical)
  }
  
  override public static func primaryKey() -> String? {
    return "character"
  }
}

public extension RealmRadical {
  
  public func update(radicalInfo: RadicalInfo) {
    character = radicalInfo.character
    meaning = radicalInfo.meaning
    image = radicalInfo.image
    level = radicalInfo.level
    percentage = radicalInfo.percentage
    userSpecific?.update(userSpecificInfo: radicalInfo.userSpecific)
  }
  
}
