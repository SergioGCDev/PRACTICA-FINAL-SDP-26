//
//  GridMangaCard.swift
//  Tankodex
//
//  Created by Sergio García on 11/2/26.
//

import SwiftUI

/// Celda de cuadrícula que muestra el título y el título japonés de un manga en disposición horizontal.
struct GridMangaCard: View {
    /// Manga cuyos títulos se muestran en la celda.
    let manga: Manga
    
    var body: some View {
        HStack {
            Text(manga.title)
                .font(.headline)
            Text(manga.formattedJapaneseTitle)
                .font(.subheadline)
        }
    }
}

#Preview {
    GridMangaCard(manga: .test2)
}
