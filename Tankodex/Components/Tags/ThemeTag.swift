//
//  ThemeTag.swift
//  Tankodex
//
//  Created by Sergio García on 2/3/26.
//


import SwiftUI

/// Etiqueta de solo lectura que muestra el nombre de una temática como pastilla coloreada.
struct ThemeTag: View {
    /// Temática que representa la etiqueta.
    let theme: Theme
    
    /// Color base para las temáticas. 
    /// Usamos indigo para diferenciar visualmente los temas de los géneros.
    private let themeColor: Color = .indigo
    
    var body: some View {
        Text(theme.rawValue)
            .font(.footnote)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(themeColor.opacity(0.2))
            .foregroundStyle(themeColor)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(themeColor.opacity(0.4), lineWidth: 1)
            }
    }
}

#Preview {
    VStack(spacing: 12) {
        ThemeTag(theme: .psychological)
        ThemeTag(theme: .samurai)
        
        Text("Testing:")
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.top)
        
        // Simulación de cómo quedaría en el DetailView
        HStack {
            ThemeTag(theme: .school)
            ThemeTag(theme: .gore)
        }
    }
    .padding()
}
