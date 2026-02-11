//
//  HomeView.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(MangaListViewModel.self) private var viewModel
    
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
            if viewModel.mangas.isEmpty {
                await viewModel.loadMangas()
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
                    ForEach(viewModel.topFiveMangas) { manga in
                        FeaturedMangaCard(manga: manga)
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
                ForEach(viewModel.recentMangas) { manga in
                    MangaRow(manga: manga)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    @Previewable @State var viewModel = MangaListViewModel(repository: NetworkTest())
    
    HomeView()
        .environment(viewModel)
        .task {
            await viewModel.loadMangas()
        }
}
