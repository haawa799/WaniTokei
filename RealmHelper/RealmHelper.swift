//
//  RealmHelper.swift
//  WaniTokei
//
//  Created by Andriy K. on 9/1/16.
//  Copyright © 2016 haawa. All rights reserved.
//

import Foundation
import RealmSwift
import TokeiModel

public struct RealmHelper {
  
  var realm: Realm {
    return try! Realm()
  }
  let realmQueue = DispatchQueue(label: "RealmQueue")
  
  public init() {
  }
  
  public func fetchRealmCriticalItems(handler: @escaping (RealmReviewItemsList)->()) {
    realmQueue.async {
      let criticalItems = self.createListIfDoesntExist()
      handler(criticalItems)
    }
  }
  
  public func fetchComplicationItems(handler: @escaping ([ComplicationItem])->()) {
    realmQueue.async {
      let items = self.realm.objects(RealmComplicationItem.self).sorted(byProperty: "date")
      let array = Array(items).map({ $0.item })
      handler(array)
    }
  }
  
  public func currentComplicationItem(handler: @escaping (ComplicationItem?)->()) {
    realmQueue.async {
      let predicate = NSPredicate(format: "date < %@", NSDate())
      let results = self.realm.objects(RealmComplicationItem.self).filter(predicate)
      guard let res = results.last else {
        handler(nil)
        return
      }
      handler(res.item)
    }
  }
  
  public func pastItems(date: NSDate, handler: @escaping ([ComplicationItem])->()) {
    realmQueue.async {
      let predicate = NSPredicate(format: "date < %@", date)
      let results = self.realm.objects(RealmComplicationItem.self).filter(predicate).sorted(byProperty: "date")
      let res = Array(results).map({ $0.item })
      handler(res)
    }
  }
  
  public func futureItems(date: NSDate, limit: Int, handler: @escaping ([ComplicationItem])->()) {
    realmQueue.async {
      let predicate = NSPredicate(format: "date > %@", date)
      let results = self.realm.objects(RealmComplicationItem.self).filter(predicate).sorted(byProperty: "date")
      let limitedResults = results.prefix(limit)
      let res = Array(limitedResults).map({ $0.item })
      handler(res)
    }
  }
  
  private func createListIfDoesntExist() -> RealmReviewItemsList {
    let allLists = realm.objects(RealmReviewItemsList.self)
    var criticalItems: RealmReviewItemsList
    if let list = allLists.first {
      criticalItems = list
    } else {
      // Create list
      criticalItems = RealmReviewItemsList()
      try! realm.write {
        realm.add(criticalItems)
      }
    }
    return criticalItems
  }
  
  public func saveCriticalItemsToRealm(list: [Item], completion: @escaping ()->()) {
    realmQueue.async {
      let criticalItems = self.createListIfDoesntExist()
      self.realm.beginWrite()
      self.realm.delete(self.realm.objects(RealmRadical.self))
      self.realm.delete(self.realm.objects(RealmKanji.self))
      self.realm.delete(self.realm.objects(RealmWord.self))
      self.realm.delete(self.realm.objects(RealmReviewItem.self))
      criticalItems.populateWithNewItems(items: list)
      try! self.realm.commitWrite()
      completion()
    }
  }
  
  public func saveComplicationItems(list: [RealmComplicationItem], completion: @escaping ()->()) {
    realmQueue.async {
      self.realm.beginWrite()
      self.realm.delete(self.realm.objects(RealmComplicationItem.self))
      self.realm.add(list)
      try! self.realm.commitWrite()
      completion()
    }
  }
  
  public func fetchItemForComplication(complication: ComplicationItem, handler: @escaping (Item?)->()) {
    realmQueue.async {
      let results = self.realm.objects(RealmReviewItem.self).filter("text = '\(complication.text)' AND type = \(complication.type)")
      handler(results.first?.item)
    }
  }
  
}
