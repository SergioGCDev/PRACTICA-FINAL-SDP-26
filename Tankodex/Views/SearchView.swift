//
//  SearchView.swift
//  Tankodex
//
//  Created by Sergio García on 11/2/26.
//

import SwiftUI

struct SearchView: View {
    @Environment(searchVM.self) private var searchViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Filtros de género
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Genre.allCases, id: \.self) { genre in
                            GenreFilterButton(
                                genre: genre,
                                isSelected: searchViewModel.filteredGenre == genre
                            ) {
                                searchViewModel.filterByGenre(genre)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Lista de mangas
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(searchViewModel.mangas) { manga in
                            MangaRow(
                                manga: manga,
                                displayedGenres: searchViewModel.displayGenres(for: manga)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Buscar")
            .task {
                if searchViewModel.mangas.isEmpty {
                    await searchViewModel.loadMangas()  // ← Método correcto
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var searchViewModel = searchVM(repository: NetworkTest())
    
    SearchView()
        .environment(searchViewModel)
        .task {
            await searchViewModel.loadMangas()
        }
}
