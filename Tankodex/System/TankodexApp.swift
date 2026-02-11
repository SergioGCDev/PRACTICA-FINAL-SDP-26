//
//  TankodexApp.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI

@main
struct TankodexApp: App {
    @State private var mangaListVM = MangaListViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
            .environment(mangaListVM)
        }
    }
}
