//
//  HomeView.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(generalVM.self) private var generalViewModel
    @Environment(libraryVM.self) private var libraryViewModel
    
    @State private var showProfile = false
    @State private var showSettings = false
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
            Group {
                if horizontalSizeClass == .regular {
                    layoutiPad
                } else {
                    layoutiPhone
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
    
        // MARK: - Layouts
    
    private var layoutiPad: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Popular")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .accessibilityAddTraits(.isHeader)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(generalViewModel.topTenMangas) { manga in
                            FeaturedMangaCard(manga: manga)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Text("All Mangas")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .accessibilityAddTraits(.isHeader)
                
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(generalViewModel.allMangas(excluding: generalViewModel.topTenMangas)
, id: \.id) { manga in
                        MangaRow(manga: manga, displayedGenres: manga.genres)
                            .task {
                                if manga.id == generalViewModel.allMangas(excluding: generalViewModel.topTenMangas)
.last?.id {
                                    await generalViewModel.loadNextPage()
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
    }
    
    private var layoutiPhone: some View {
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
            
            Section {
                Text("All Mangas")
                    .font(.title2)
                    .fontWeight(.bold)
                    .listRowSeparator(.hidden)
                
                ForEach(generalViewModel.allMangas(excluding: generalViewModel.topFiveMangas)
, id: \.id) { manga in
                    MangaRow(manga: manga, displayedGenres: manga.genres)
                        .listRowSeparatorTint(.tankodexSecondary.opacity(0.2))
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                        .task {
                            if manga.id == generalViewModel.allMangas(excluding: generalViewModel.topFiveMangas)
.last?.id {
                                await generalViewModel.loadNextPage()
                            }
                        }
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    @Previewable @State var generalViewModel = generalVM(repository: NetworkTest())

    let container = try! ModelContainer(for: MangaCollection.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    let vm = libraryVM(modelContainer: container)

    return HomeView()
        .environment(generalViewModel)
        .environment(vm)
        .task {
            await generalViewModel.loadMangas()
        }
}
