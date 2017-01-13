//
//  ViewController.swift
//  WaniTokei
//
//  Created by Andriy K. on 1/10/17.
//  Copyright © 2017 haawa. All rights reserved.
//

import UIKit
import WaniLoginKit
import WatchConnectivity

class ViewController: UIViewController {
  
  struct Key {
    static let apiKeyWasSentToWatch = "apiKeyWasSentToWatch"
    static let apiKey = "apiKey"
  }
  
  @IBOutlet weak var statusLabel: UILabel! {
    didSet {
      let text = apiKeyWasSentToWatch ? "API key successfully sent to watch." : "API key not yet sent to watch."
      statusLabel?.text = text
    }
  }
  
  @IBAction func syncAction(_ sender: Any) {
    sendApiKey(apiKey: waniLoginController?.apiKey)
  }
  
  lazy var waniLoginController: WaniLoginCoordinator? = {
    return (UIApplication.shared.delegate as? AppDelegate)?.waniLoginCoordinator
  }()
  
  var apiKeyWasSentToWatch: Bool {
    return UserDefaults.standard.bool(forKey: Key.apiKeyWasSentToWatch)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if apiKeyWasSentToWatch == false {
      sendApiKey(apiKey: waniLoginController?.apiKey)
    }
  }
  
  func sendApiKey(apiKey: String?) {
    guard let apiKey = apiKey else { return }
    WCSession.default().sendMessage([Key.apiKey: apiKey], replyHandler: { (_) in
      UserDefaults.standard.set(true, forKey: Key.apiKeyWasSentToWatch)
      DispatchQueue.main.async {
        self.statusLabel?.text = "API key successfully sent to watch."
      }
    }) { (_) in
      self.showSessionStatus(session: WCSession.default())
    }
  }
  
  func showSessionStatus(session: WCSession) {
    let status: String
    if session.isReachable {
      status = "Watch reachable"
    } else {
      if session.isWatchAppInstalled {
        status = "Watch app installed"
      } else {
        status = "Watch app not installed"
      }
    }
    DispatchQueue.main.async {
      self.statusLabel?.text = status
    }
  }
  
}
