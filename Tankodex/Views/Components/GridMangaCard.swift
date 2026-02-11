//
//  GridMangaCard.swift
//  Tankodex
//
//  Created by Sergio García on 11/2/26.
//

import SwiftUI

struct GridMangaCard: View {
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
