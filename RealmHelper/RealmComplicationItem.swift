//
//  RealmComplicationItem.swift
//  WaniTokei
//
//  Created by Andriy K. on 9/6/16.
//  Copyright © 2016 haawa. All rights reserved.
//

import Foundation
import RealmSwift
import TokeiModel

public class RealmComplicationItem: Object {
  public dynamic var text = ""
  public dynamic var shortText: String?
  public dynamic var date: Date = Date()
  
  public var itemType: RealmReviewItem.ItemType {
    return RealmReviewItem.ItemType(rawValue: type)!
  }
  public dynamic var type: Int = 0
  
  public static func newItem(itemInfo: Item, date: Date) -> RealmComplicationItem {
    let item = RealmComplicationItem()
    switch itemInfo {
    case .radical(let radicalInfo):
      item.text = radicalInfo.character ?? ""
      item.shortText = radicalInfo.character
      item.type = RealmReviewItem.ItemType.Radical.rawValue
    case .kanji(let kanjiInfo):
      item.text = kanjiInfo.character
      item.shortText = kanjiInfo.character
      item.type = RealmReviewItem.ItemType.Kanji.rawValue
    case .word(let wordInfo):
      item.text = wordInfo.character
      item.shortText = wordInfo.character
      item.type = RealmReviewItem.ItemType.Word.rawValue
    }
    item.date = date
    return item
  }
  
  public var item: ComplicationItem {
    let item = ComplicationItem(text: text, shortText: shortText, date: date, color: itemType.color, type: type)
    return item
  }
  
}
