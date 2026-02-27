    //
    //  HomeView.swift
    //  Tankodex
    //
    //  Created by Sergio García on 10/2/26.
    //

import SwiftUI
import SwiftData

struct NewsView: View {
    
    @Environment(generalVM.self) private var generalViewModel
    @Environment(libraryVM.self) private var libraryViewModel
    
    @State private var showProfile = false
    @State private var showSettings = false
    
        // iPad
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
            Group {
                if horizontalSizeClass == .regular {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            bestMangasSection
                            recentMangasSection
                        }
                        .padding(.top)
                    }
                } else {
                    List {
                        Section {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(generalViewModel.topFiveMangas) { manga in
                                        FeaturedMangaCard(manga: manga)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .listRowInsets(EdgeInsets())
                        }
                        
                        Section("Recently Added") {
                            ForEach(generalViewModel.recentMangas, id: \.id) { manga in
                                MangaRow(manga: manga, displayedGenres: manga.genres)
                            }
                        }
                    }
                    .listStyle(.inset)
                }
            }
            .navigationTitle("Tankōdex")
            .toolbar {
                ToolbarGeneral(showProfile: $showProfile, showSettings: $showSettings)
            }
        }
        
        .sheet(isPresented: $showProfile) {
            ProfileSheetView()
                .environment(libraryViewModel)
                .presentationSizing(.form)
        }
        .sheet(isPresented: $showSettings) {
            SettingsSheetView()
                .presentationSizing(.form)
        }
        .task {
            if generalViewModel.mangas.isEmpty {
                await generalViewModel.loadMangas()
            }
        }
    }
        // MARK: - Subviews
    
    private var bestMangasSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Popular")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .accessibilityAddTraits(.isHeader)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                        // Si es iPad, mostrará tenMangas, sino, mostrará fiveMangas.
                    let mangas = horizontalSizeClass == .regular ? generalViewModel.topTenMangas : generalViewModel.topFiveMangas
                    ForEach(mangas) { manga in
                        FeaturedMangaCard(manga: manga)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
    }
    
    private var recentMangasSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently Added")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .accessibilityAddTraits(.isHeader)
            if horizontalSizeClass == .regular {
                    // iPad - Grid de 2 columnas
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(generalViewModel.recentMangas, id: \.id) { manga in
                        MangaRow(manga: manga, displayedGenres: manga.genres)
                    }
                }
                .padding(.horizontal)
            } else {
                    // iPhone - List normal
                List(generalViewModel.recentMangas, id: \.id) { manga in
                    MangaRow(manga: manga, displayedGenres: manga.genres)
                }
                .listStyle(.inset)
            }
        }
    }
}

#Preview {
    @Previewable @State var generalViewModel = generalVM(repository: NetworkTest())
    
    let container = try! ModelContainer(
        for: MangaCollection.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let vm = libraryVM(modelContainer: container)
    
    return NewsView()
        .environment(generalViewModel)
        .environment(vm)
        .task {
            await generalViewModel.loadMangas()
        }
}
