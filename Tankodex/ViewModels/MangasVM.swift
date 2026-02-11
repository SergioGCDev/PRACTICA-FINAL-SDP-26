    //
    //  MangasVM.swift
    //  Tankodex
    //
    //  Created by Sergio García on 10/2/26.
    //

import Foundation

@MainActor
@Observable
final class MangaListViewModel {
        // MARK: - State
    private(set) var mangas: [Manga] = []
    private(set) var metadata: PaginationMetadata?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
        // MARK: - Dependencies
    private let repository: NetworkRepository
    
        // MARK: - Configuration
    private let itemsPerPage = 20
    private var currentPage = 1
    
        // MARK: - Initialization
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }
    
    
        // MARK: Computed Properties
    var topFiveMangas: [Manga] {
        mangas
            .sorted { $0.score > $1.score }
            .prefix(5)
            .map { $0 }
    }
    
    var recentMangas: [Manga] {
        mangas
        // .distantPast = Constante de Date -> Date.distantPast = 01/01/0001
        //                                     Date.distantFuture = 31/12/4001
            .sorted { ($0.startDate ?? .distantPast) > ($1.startDate ?? .distantPast) }
            .prefix(10)
            .map { $0 }
    }
        // MARK: - Public Methods
    func loadMangas() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await repository.getMangas(
                page: currentPage,
                perPage: itemsPerPage
            )
            
            mangas = result.mangas
            metadata = result.metadata
            
        } catch {
                // Con typed throws, 'error' ya es NetworkError automáticamente
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadNextPage() async {
        guard let metadata,
              metadata.hasMorePages,
              !isLoading else { return }
        
        currentPage += 1
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await repository.getMangas(
                page: currentPage,
                perPage: itemsPerPage
            )
            
            mangas.append(contentsOf: result.mangas)
            self.metadata = result.metadata
            
        } catch {
            errorMessage = error.localizedDescription
            currentPage -= 1
        }
        
        isLoading = false
    }
    
    func retry() async {
        currentPage = 1
        await loadMangas()
    }
}
