//
//  ContentView.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI

struct ContentView: View {
    let tst = true
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
            }
            
            Tab("Library", systemImage: "books.vertical.fill") {
                ProfileView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(generalVM(repository: NetworkTest()))
}
