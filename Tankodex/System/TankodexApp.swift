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
    @State private var showLoading = true

    @AppStorage("colorScheme") private var colorScheme: String = "system"

    var body: some Scene {
        WindowGroup {
            if let libraryViewModel {
                RootContent(showLoadingOverlay: showLoading)
                    .environment(generalViewModel)
                    .environment(searchViewModel)
                    .environment(libraryViewModel)
                    .preferredColorScheme(resolvedColorScheme)
                    .task {
                        async let dataLoad: () = generalViewModel.loadMangas()
                        async let minimumTime: () = Task.sleep(for: .seconds(2.5))
                        _ = try? await (dataLoad, minimumTime)
                        withAnimation(.easeOut(duration: 0.4)) {
                            showLoading = false
                        }
                    }
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
