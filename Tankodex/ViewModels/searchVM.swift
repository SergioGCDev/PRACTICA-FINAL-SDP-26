    //
    //  SearchViewModel.swift
    //  Tankodex
    //
    //  Created by Sergio García on 10/2/26.
    //

import Foundation

@MainActor
@Observable
final class searchVM {
        // MARK: - State
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
        // MARK: - Filters
    private(set) var filteredGenre: Genre?
    
        // MARK: - Pagination
    private let pagination = PaginationController(itemsPerPage: 20)
    
        // MARK: - Dependencies
    private let repository: NetworkRepository
    
        // MARK: - Initialization
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }
    
        // MARK: - Computed Properties (exponer datos de pagination)
    
    var mangas: [Manga] {
        pagination.mangas
    }
    
    var metadata: PaginationMetadata? {
        pagination.metadata
    }
    
        // MARK: - Public Methods
    
    func filterByGenre(_ genre: Genre?) {
        filteredGenre = genre
        pagination.reset()  // ← Resetear paginación
        
        Task {
            await loadMangas()
        }
    }
    
    func loadMangas() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await pagination.loadInitialPage(  // ← Usar controlador
                from: repository,
                genre: filteredGenre  // ← Pasar filtro
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadNextPage() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await pagination.loadNextPage(  // ← Usar controlador
                from: repository,
                genre: filteredGenre  // ← Pasar filtro
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func retry() async {
        pagination.reset()
        await loadMangas()
    }
    
        // MARK: - Display Logic
    
    func displayGenres(for manga: Manga, limit: Int = 3) -> [Genre] {
        guard let filteredGenre else {
            return Array(manga.genres.prefix(limit))
        }
        
        var result: [Genre] = []
        
        if manga.genres.contains(filteredGenre) {
            result.append(filteredGenre)
        }
        
        let remaining = manga.genres.filter { $0 != filteredGenre }
        result.append(contentsOf: remaining.prefix(limit - result.count))
        
        return result
    }
}
