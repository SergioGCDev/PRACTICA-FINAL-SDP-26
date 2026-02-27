    //
    //  ProfileView.swift
    //  Tankodex
    //
    //  Created by Sergio García on 11/2/26.
    //

import SwiftUI
import SwiftData

/// Vista principal de la biblioteca personal que agrupa la colección del usuario por estado de lectura.
struct LibraryView: View {

    @Environment(libraryVM.self) private var libraryViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var selectedManga: Manga?
    @State private var showProfile = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            Group {
                if libraryViewModel.collection.isEmpty {
                    ContentUnavailableView(
                        "Your library is empty",
                        systemImage: "books.vertical",
                        description: Text("Add manga from Search or News")
                    )
                } else {
                    if horizontalSizeClass == .regular {
                        ipadLayout
                    } else {
                        iphoneLayout
                    }
                }
            }
            .navigationTitle("My Library")
            .toolbar {
                ToolbarGeneral(showProfile: $showProfile, showSettings: $showSettings)
            }
            
            .sheet(isPresented: $showProfile){
                ProfileSheetView()
                    .environment(libraryViewModel)
                    .presentationSizing(.form)
            }
            
            .sheet(isPresented: $showSettings){
                SettingsSheetView()
                    .presentationSizing(.form)
            }
            .sheet(item: $selectedManga){ manga in
                MangaDetailView(manga: manga)
                    .environment(libraryViewModel)
                    .presentationSizing(.form)
            }
            .task {
                await libraryViewModel.loadCollection()
            }
        }
    }
        // MARK: - iPhone Layout
    private var iphoneLayout: some View {
        List {
            ForEach(ReadingStatus.allCases, id: \.self) { status in
                let items = libraryViewModel.collection.filter { $0.status == status }
                if !items.isEmpty {
                    Section(status.rawValue) {
                        ForEach(items) { item in
                            libraryButton(item: item)
                        }
                    }
                }
            }
        }
    }
    
        // MARK: - iPad Layout
    private var ipadLayout: some View {
        ScrollView {
            ForEach(ReadingStatus.allCases, id: \.self) { status in
                let items = libraryViewModel.collection.filter { $0.status == status }
                if !items.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(status.rawValue)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        let columns = [GridItem(.flexible()), GridItem(.flexible())]
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(items) { item in
                                libraryButton(item: item)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 8)
                }
            }
        }
    }
    
    private func libraryButton(item: MangaCollectionDTO) -> some View {
        Button {
            Task {
                selectedManga = await libraryViewModel.loadManga(id: item.mangaId)
            }
        } label: {
            if horizontalSizeClass == .regular {
                LibraryCard(item: item)
            } else {
                LibraryRow(item: item)
            }
        }
        .tint(.primary)
    }
}

#Preview {
    let container = try! ModelContainer(
        for: MangaCollection.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    let context = container.mainContext
    context.insert(MangaCollection(mangaId: 1, title: "Berserk", coverURL: nil, volumesBought: 30, totalVolumes: 40, currentVolume: 15, isCompleted: false, status: .collected))
    context.insert(MangaCollection(mangaId: 2, title: "Naruto", coverURL: nil, volumesBought: 72, totalVolumes: 72, currentVolume: 72, isCompleted: true, status: .completed))
    context.insert(MangaCollection(mangaId: 3, title: "One Piece", coverURL: nil, volumesBought: 5, totalVolumes: 107, currentVolume: 3, isCompleted: false, status: .reading))
    context.insert(MangaCollection(mangaId: 4, title: "Vinland Saga", coverURL: nil, volumesBought: 0, totalVolumes: 27, currentVolume: 0, isCompleted: false, status: .wishlist))
    
    let vm = libraryVM(modelContainer: container)
    
    return LibraryView()
        .environment(vm)
}
