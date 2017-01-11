//
//  AppDelegate.swift
//  WaniTokei
//
//  Created by Andriy K. on 8/29/16.
//  Copyright © 2016 haawa. All rights reserved.
//

import UIKit
import WatchConnectivity
import WaniLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var waniLoginCoordinator: WaniLoginCoordinator?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let q = WaniLoginCoordinator()
    q.start(window: window!)
    q.delegate = self
    self.waniLoginCoordinator = q
    
    // Setup session
    if WCSession.isSupported() {
      let wcsession = WCSession.default()
      wcsession.delegate = self
      wcsession.activate()
    }
    
    return true
  }
  
}

extension AppDelegate: WCSessionDelegate {
  
  @available(iOS 9.3, *)
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) {
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
  }
  
}

extension AppDelegate: WaniLoginCoordinatorDelegate {
  
  func loginEndedWithResult(result: LoginResult, coordinator: WaniLoginCoordinator) {
    switch result {
    case .success(let apiKey): WCSession.default().sendMessage(["apiKey": apiKey], replyHandler: nil, errorHandler: nil)
    default: return
    }
  }
  
}
