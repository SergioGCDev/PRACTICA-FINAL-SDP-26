    //
    //  SearchView.swift
    //  Tankodex
    //
    //  Created by Sergio García on 11/2/26.
    //

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(searchVM.self) private var searchViewModel
    @Environment(libraryVM.self) private var libraryViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    
    @State private var showProfile = false
    @State private var showSettings = false
    
    private var demographicBinding: Binding<Demographic> {
        Binding(
            get: { searchViewModel.filteredDemographic },
            set: { searchViewModel.filterByDemographic($0) }
        )
    }
    
    var body: some View {
        @Bindable var vm = searchViewModel
        NavigationStack {
            VStack {
                    // Filtro de demographic
                Picker("Demographic", selection: demographicBinding) {
                    ForEach(Demographic.allCases, id: \.self) { demographic in
                        Image(systemName: demographic.icon).tag(demographic)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: searchViewModel.filteredDemographic) { _, newValue in
                    searchViewModel.filterByDemographic(newValue)
                }
                
                    // Lista de mangas
                Group {
                    if horizontalSizeClass == .regular {
                        ScrollView {
                            LazyVGrid(columns: columns) {
                                ForEach(vm.filteredMangas) { manga in
                                    MangaRow(manga: manga, displayedGenres: manga.genres)
                                        .task {
                                            await vm.loadNextPageIfNeeded(manga: manga)
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        List(vm.filteredMangas) { manga in
                            MangaRow(manga: manga, displayedGenres: manga.genres)
                                .task {
                                    await vm.loadNextPageIfNeeded(manga: manga)
                                }
                        }
                        .listStyle(.inset)
                    }
                }
                .searchable(text: $vm.searchText)
                .onChange(of: searchViewModel.searchText) { _, newValue in
                    if newValue.count >= 3 || newValue.isEmpty {
                        searchViewModel.onSearchTextChanged()
                    }
                }
            }
            .navigationTitle("Search")
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
            
            .task {
                if searchViewModel.mangas.isEmpty {
                    await searchViewModel.loadMangas()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var searchViewModel = searchVM(repository: NetworkTest())
    
    let container = try! ModelContainer(
        for: MangaCollection.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let vm = libraryVM(modelContainer: container)
    
    return SearchView()
        .environment(searchViewModel)
        .environment(vm)
        .task {
            await searchViewModel.loadMangas()
        }
}
