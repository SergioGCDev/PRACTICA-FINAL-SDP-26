//
//  SettingsSheetView.swift
//  Tankodex
//
//  Created by Sergio García on 26/2/26.
//

import SwiftUI

struct SettingsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("colorScheme") private var colorScheme: String = "system"
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Appearance
                Section("Appearance") {
                    HStack {
                        Label("Theme", systemImage: "circle.lefthalf.filled")
                        Spacer()
                        Picker("Theme", selection: $colorScheme) {
                            Text("System").tag("system")
                            Text("Light").tag("light")
                            Text("Dark").tag("dark")
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    }
                }
                
                // MARK: - Language
                Section("Language") {
                    HStack {
                        Label("Language", systemImage: "globe")
                        Spacer()
                        Text("Coming soon")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.secondary.opacity(0.15))
                            .clipShape(.capsule)
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .preferredColorScheme(resolvedColorScheme)
    }
    
    private var resolvedColorScheme: ColorScheme? {
        switch colorScheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
