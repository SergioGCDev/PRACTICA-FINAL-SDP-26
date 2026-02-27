//
//  MangaCard.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI

/// Tarjeta que muestra la portada de un manga destacado y abre su detalle al pulsarla.
struct FeaturedMangaCard: View {
    /// Manga cuyos datos se muestran en la tarjeta.
    let manga: Manga
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(libraryVM.self) private var libraryViewModel
    @State private var showDetail = false

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: manga.mainPicture) { mangaImage in
                mangaImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: horizontalSizeClass == .regular ? 250 : 150)
            } placeholder: {
                ProgressView()
            }
            
            if horizontalSizeClass == .regular {
                Text(manga.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .frame(width: 180)
            }
        }
        .onTapGesture {
            showDetail = true
        }
        .sheet(isPresented: $showDetail) {
            MangaDetailView(manga: manga)
                .environment(libraryViewModel)
                .presentationSizing(.page)
        }
    }
}
#Preview {
    FeaturedMangaCard(manga: .test2)
}
