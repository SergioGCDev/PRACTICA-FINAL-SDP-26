//
//  HomeView.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(generalVM.self) private var generalViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    bestMangasSection
                    recentMangasSection
                }
                .padding(.top)
            }
            .navigationTitle("Tankōdex")
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
            Text("Best Mangas")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .accessibilityAddTraits(.isHeader)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(generalViewModel.topFiveMangas) { manga in
                        FeaturedMangaCard(
                            manga: manga
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var recentMangasSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently Added")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .accessibilityAddTraits(.isHeader)
            
            LazyVStack(alignment:.leading, spacing: 12) {
                ForEach(generalViewModel.recentMangas) { manga in
                    MangaRow(manga: manga, displayedGenres: manga.genres)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    @Previewable @State var generalViewModel = generalVM(repository: NetworkTest())
    
    HomeView()
        .environment(generalViewModel)
        .task {
            await generalViewModel.loadMangas()
        }
}
