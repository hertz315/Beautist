//
//  BueatistApp.swift
//  Bueatist
//
//  Created by Hertz on 12/9/22.
//

import SwiftUI

@main
struct BeautistApp: App {
    
    @StateObject var beautistVM = BueatistViewModel()
    @StateObject var beautistRxVM = BeautistViewModelRx()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
