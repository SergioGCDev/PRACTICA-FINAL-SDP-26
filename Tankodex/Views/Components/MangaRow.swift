//
//  MangaRow.swift
//  Tankodex
//
//  Created by Sergio García on 11/2/26.
//

import SwiftUI

struct MangaRow: View {
    let manga: Manga
    let displayedGenres: [Genre]  // ← Recibe géneros YA procesados
    
    var body: some View {
        HStack {
            AsyncImage(url: manga.mainPicture) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
            } placeholder: {
                ProgressView()
            }

            VStack(alignment: .leading) {
                
                Text(manga.title)
                        .font(.headline)
                        .lineLimit(2)
                if !manga.formattedJapaneseTitle.isEmpty {
                    Text(manga.formattedJapaneseTitle)
                        .font(.subheadline)
                        .lineLimit(1)
                }
                
                Text("Volumes: \(manga.volumes ?? 0)")
                Text("Chapters: \(manga.chapters ?? 0)")
                    // Demographic con emoji
                if let demographic = manga.demographics.first {
                    DemographicTag(demographic: demographic, style: .withText)
                }
                
                    // Géneros
                HStack(spacing: 4) {
                    ForEach(manga.genres.prefix(3), id: \.self) { genre in
                        GenreTag(genre: genre)
                    }
                }
                
            }
            
        }
    }
}

#Preview {
    MangaRow(manga: .test2, displayedGenres: [.action, .drama])
    MangaRow(manga: .test3, displayedGenres: [.comedy, .erotica])
}

