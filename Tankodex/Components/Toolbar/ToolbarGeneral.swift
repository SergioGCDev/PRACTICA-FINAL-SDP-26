//
//  ToolbarGeneral.swift
//  Tankodex
//
//  Created by Sergio García on 22/2/26.
//


import SwiftUI

struct ToolbarGeneral: ToolbarContent {

        ///
/// Para usar en Views:
///
//     @State private var showProfile = false
//     @State private var showSettings = false
///
/// En toolbar:
///
//     .toolbar {
//         ToolbarGeneral(showProfile: $showProfile, showSettings: $showSettings)
//     }
//     .sheet(isPresented: $showProfile) {
//         ProfileSheetView()
//     }
//     .sheet(isPresented: $showSettings) {
//         SettingsSheetView()
//     }
//
    @Binding var showProfile: Bool
    @Binding var showSettings: Bool
    
    // Foto de perfil guardado en Local.
    @AppStorage("username") private var username: String = ""
    @AppStorage("hasProfilePhoto") private var hasProfilePhoto: Bool = false
    
    var body: some ToolbarContent {
        ToolbarItem {
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
            }
        }
        
        ToolbarItem {
            Button {
                showProfile = true
            } label: {
                profileIcon
            }
        }
    }
    
    @ViewBuilder
    private var profileIcon: some View {
        if hasProfilePhoto,
           let image = loadProfilePhoto() {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 28, height: 28)
                .clipShape(.circle)
        } else {
            Image(systemName: "person.fill")
        }
    }
    
    private func loadProfilePhoto() -> UIImage? {
        guard let data = UserDefaults.standard.data(forKey: "profilePhoto") else { return nil }
        return UIImage(data: data)
    }
}
