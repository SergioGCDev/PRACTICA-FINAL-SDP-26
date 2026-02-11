//
//  MangaCard.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI

struct FeaturedMangaCard: View {
    let manga: Manga
        
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(manga.title.uppercased())
                        .font(.headline)
                    Label(manga.score.description, systemImage: "star.fill")
                        .font(.caption)
                }
                
                AsyncImage(url: manga.mainPicture) { mangaImage in
                   mangaImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200)
                } placeholder: {
                    ProgressView()
                }
            }
            
        }
        .frame(width: 300, height: 200)
        .padding()
        .background(.black.opacity(0.1), in: .rect(cornerRadius: 8))
        
    }
}

#Preview {
    FeaturedMangaCard(manga: .test2)
}
