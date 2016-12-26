//
//  ComplicationController.swift
//  WaniTokei
//
//  Created by Andriy K. on 8/29/16.
//  Copyright © 2016 haawa. All rights reserved.
//

import ClockKit
import TokeiModel

public class ComplicationController: NSObject, CLKComplicationDataSource {
    
  let persistanceManager = PersistanceManager.sharedInstance
  
  // MARK: Register
  
  public func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Swift.Void) {
    handler(Date().dateByAddingDays(-2))
  }
  
  public func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Swift.Void) {
    handler(Date().dateByAddingDays(2))
  }
  
  public func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Swift.Void) {
    handler([.backward, .forward])
  }
  
  public func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Swift.Void) {
    persistanceManager.currentComplicationItem { (item) in
      guard let item = item else {
        handler(nil)
        return
      }
      let template = item.complicationTemplateForFamily(family: complication.family)
      let timelineEntry = CLKComplicationTimelineEntry(date: item.date, complicationTemplate: template)
      handler(timelineEntry)
    }
  }
  
  public func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Swift.Void) {
    persistanceManager.pastItems(countDate: date as NSDate) { (items) in
      let entries = items.map({ CLKComplicationTimelineEntry(date: $0.date, complicationTemplate: $0.complicationTemplateForFamily(family: complication.family)) })
      handler(entries)
    }
  }
  
  public func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Swift.Void) {
    persistanceManager.futureItems(date: date as NSDate, limit: limit) { (items) in
      let entries = items.map({ CLKComplicationTimelineEntry(date: $0.date, complicationTemplate: $0.complicationTemplateForFamily(family: complication.family)) })
      handler(entries)
    }
  }
  
  public func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Swift.Void) {
    handler(.showOnLockScreen)
  }
  
}


extension ComplicationItem {
  
  static func complicationTemplateForText(text: String, family: CLKComplicationFamily) -> CLKComplicationTemplate {
    switch family {
    case .modularSmall:
      let template = CLKComplicationTemplateModularSmallSimpleText()
      template.textProvider = CLKSimpleTextProvider(text: text)
      return template
    case .modularLarge:
      let template = CLKComplicationTemplateModularLargeTallBody()
      template.bodyTextProvider = CLKSimpleTextProvider(text: text)
      return template
    case .utilitarianSmall:
      let template = CLKComplicationTemplateUtilitarianSmallRingText()
      template.textProvider = CLKSimpleTextProvider(text: text)
      return template
    case .utilitarianLarge:
      let template = CLKComplicationTemplateUtilitarianLargeFlat()
      template.textProvider = CLKSimpleTextProvider(text: text)
      return template
    case .utilitarianSmallFlat:
      let template = CLKComplicationTemplateUtilitarianSmallFlat()
      template.textProvider = CLKSimpleTextProvider(text: text)
      return template
    case .circularSmall:
      let template = CLKComplicationTemplateCircularSmallSimpleText()
      template.textProvider = CLKSimpleTextProvider(text: text)
      return template
    case .extraLarge:
      let template = CLKComplicationTemplateExtraLargeSimpleText()
      template.textProvider = CLKSimpleTextProvider(text: text)
      return template
    }
  }
  
  func complicationTemplateForFamily(family: CLKComplicationFamily) -> CLKComplicationTemplate {
    let template = ComplicationItem.complicationTemplateForText(text: text, family: family)
    template.tintColor = color
    return template
  }
  
}
