//
//  TankodexApp.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI
import SwiftData

@main
struct TankodexApp: App {
    @State private var generalViewModel = generalVM()
    @State private var searchViewModel = searchVM()
    @State private var libraryViewModel: libraryVM?
    
    @AppStorage("colorScheme") private var colorScheme: String = "system"
    
    var body: some Scene {
        WindowGroup {
            if let libraryViewModel {
                ContentView()
                    .environment(generalVM())
                    .environment(searchVM())
                    .environment(libraryViewModel)
            }
        }
        .modelContainer(for: MangaCollection.self) { result in
            guard case .success(let container) = result else { return }
            libraryViewModel = libraryVM(modelContainer: container)
        }
    }
    
    private var resolvedColorScheme: ColorScheme? {
        switch colorScheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
