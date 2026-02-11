//
//  ContentView.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()  // ← Recibe environment automáticamente
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()  // ← También recibe environment
            }
            
            Tab("Library", systemImage: "books.vertical.fill") {
                ProfileView()  // ← También recibe environment
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(MangaListViewModel(repository: NetworkTest()))
}
