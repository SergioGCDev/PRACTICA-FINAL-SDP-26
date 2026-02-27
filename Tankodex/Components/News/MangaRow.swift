//
//  MangaRow.swift
//  Tankodex
//
//  Created by Sergio García on 11/2/26.
//

import SwiftUI
import SwiftData

struct MangaRow: View {
    let manga: Manga
    let displayedGenres: [Genre]
    
    @Environment(libraryVM.self) private var libraryViewModel
    @State private var showDetail = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                AsyncImage(url: manga.mainPicture) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 150)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 150)
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
                    
                    if let volumes = manga.volumes, volumes > 0 {
                        Text("Volumes: \(volumes)")
                    }
                    if let chapters = manga.chapters, chapters > 0 {
                        Text("Chapters: \(chapters)")
                    }
                    
                    if let demographic = manga.demographics.first {
                        DemographicTag(demographic: demographic, style: .withText)
                    }
                    
                    HStack(spacing: 4) {
                        ForEach(manga.genres.prefix(3), id: \.self) { genre in
                            GenreTag(genre: genre)
                        }
                    }
                }
                if let entry = libraryViewModel.collection.first(where: { $0.mangaId == manga.id }) {
                    Label(entry.status.rawValue, systemImage: iconFor(entry.status))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            if !libraryViewModel.isInLibrary(manga) {
                ForEach(ReadingStatus.allCases, id: \.self) { status in
                    Button {
                        Task { await libraryViewModel.addManga(manga, status: status) }
                    } label: {
                        Label(status.rawValue, systemImage: iconFor(status))
                    }
                }
            }
        }
        .onTapGesture {
            showDetail = true
        }
        .sheet(isPresented: $showDetail) {
            MangaDetailView(manga: manga)
                .environment(libraryViewModel)
                .presentationSizing(.form)
        }
    }
    
    private func iconFor(_ status: ReadingStatus) -> String {
        switch status {
        case .wishlist:  return "heart"
        case .reading:   return "book"
        case .completed: return "checkmark.circle"
        case .collected: return "shippingbox"
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: MangaCollection.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let vm = libraryVM(modelContainer: container)
    
    return List {
        MangaRow(manga: .test2, displayedGenres: [.action, .drama])
        MangaRow(manga: .test3, displayedGenres: [.comedy, .erotica])
    }
    .environment(vm)
}
