//
//  TankodexApp.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI

@main
struct TankodexApp: App {
    @State private var generalViewModel = generalVM()
    @State private var searchViewModel = searchVM()

    var body: some Scene {
        WindowGroup {
            ContentView()
            .environment(generalViewModel)
            .environment(searchViewModel)
        }
    }
}
