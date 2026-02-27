//
//  GenreTag.swift
//  Tankodex
//
//  Created by Sergio García on 12/2/26.
//


//
//  GenreTag.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI

/// Etiqueta de solo lectura que muestra el nombre de un género como pastilla coloreada.
struct GenreTag: View {
    /// Género que representa la etiqueta.
    let genre: Genre
    
    var body: some View {
        Text(genre.rawValue)
            .font(.footnote)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(genre.color.opacity(0.2))
            .foregroundStyle(genre.color)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(genre.color.opacity(0.4), lineWidth: 1)
            }
    }
}

#Preview {
    VStack(spacing: 8) {
        GenreTag(genre: .action)
        GenreTag(genre: .romance)
        GenreTag(genre: .horror)
        GenreTag(genre: .comedy)
    }
    .padding()
}
