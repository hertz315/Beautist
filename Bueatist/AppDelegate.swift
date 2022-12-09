//
//  AppDelegate.swift
//  Bueatist
//
//  Created by Hertz on 12/9/22.
//

import Foundation
import UIKit
import Parse

class AppDelegate: NSObject, UIApplicationDelegate {
    // AppDelegate.swift
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl"
            $0.clientKey = "HosWCcXxgjD3tMCfibfoe7NLwqfj8TGvC3Bng1dd"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
        return true
    }
}

