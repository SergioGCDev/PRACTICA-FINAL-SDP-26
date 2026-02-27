//
//  ContentView.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI
import SwiftData

/// Vista raíz de la aplicación que presenta un `TabView` con las pestañas de News, Library y Search.
struct ContentView: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let tst = true
    var body: some View {
        TabView {
            Tab("News", systemImage: "star.fill") {
                NewsView()
            }
            
            Tab("My Library", systemImage: "books.vertical.fill") {
                LibraryView()
            }
            
            if horizontalSizeClass == .regular {
                Tab("Search", systemImage: "magnifyingglass") {
                    SearchView()
                }
            } else {
                Tab("Search", systemImage: "magnifyingglass", role: .search) {
                    SearchView()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewSidebarBottomBar { }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: MangaCollection.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let vm = libraryVM(modelContainer: container)
    
    ContentView()
        .environment(generalVM(repository: NetworkTest()))
        .environment(searchVM(repository: NetworkTest()))
        .environment(vm)
}
