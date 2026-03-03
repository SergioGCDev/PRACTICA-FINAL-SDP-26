//
//  FeaturedMangaCard.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI
import SwiftData

/// Tarjeta que muestra información de un manga destacado y abre su detalle al pulsarla.
struct FeaturedMangaCard: View {
        /// Manga cuyos datos se muestran en la tarjeta.
    let manga: Manga
    @Environment(libraryVM.self) private var libraryViewModel
    @State private var showDetail = false
    
    private var publicationStatus: String {
        switch manga.status {
        case .finished, .discontinued: return "Finished"
        case .publishing, .onHiatus:   return "Ongoing"
        case .none:                    return "Unknown"
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: manga.mainPicture) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350, height: 220, alignment: .center)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(width: 150, height: 220)
            }
            
            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(manga.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                
                HStack(alignment: .bottom) {
                    Label(manga.formattedScore, systemImage: "star.fill")
                        .font(.subheadline)
                        .foregroundStyle(.yellow)
                    
                    Spacer()
                    
                    PublicationStatusTag(status: manga.status)
                }
            }
            .padding(8)
        }
        .frame(width: 350, height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture { showDetail = true }
        .sheet(isPresented: $showDetail) {
            MangaDetailView(manga: manga)
                .environment(libraryViewModel)
                .presentationSizing(.page)
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: MangaCollection.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let vm = libraryVM(modelContainer: container)
    
    ScrollView(.horizontal) {
        HStack(spacing: 20) {
            FeaturedMangaCard(manga: .test2)
            FeaturedMangaCard(manga: .test3)
        }
        .padding(.horizontal)
    }
    .environment(vm)
}
