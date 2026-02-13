//
//  GenreFilterButton.swift
//  Tankodex
//
//  Created by Sergio García on 12/2/26.
//

import SwiftUI

struct GenreFilterButton: View {
    let genre: Genre
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                // Punto de color
                Circle()
                    .fill(genre.color)
                    .frame(width: 6, height: 6)
                    .opacity(isSelected ? 1.0 : 0.5)
                
                Text(genre.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? genre.color.opacity(0.2) : Color.gray.opacity(0.1))
            .foregroundStyle(isSelected ? genre.color : .primary)
            .clipShape(Capsule())
            .overlay {
                if isSelected {
                    Capsule()
                        .stroke(genre.color, lineWidth: 1)
                }
            }
        }
    }
}
