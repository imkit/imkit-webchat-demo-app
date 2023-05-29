//
//  IMKitWebchatDemoAppApp.swift
//  IMKitWebchatDemoApp
//
//  Created by Howard Sun on 2023/5/28.
//

import SwiftUI

@main
struct IMKitWebchatDemoAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
