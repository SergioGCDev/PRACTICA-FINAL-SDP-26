    //
    //  PaginationController.swift
    //  Tankodex
    //
    //  Created by Sergio García on 12/2/26.
    //


import Foundation

    /// Controlador reutilizable para manejar paginación de mangas
@MainActor
@Observable
final class PaginationController {
        // MARK: - State
    private(set) var mangas: [Manga] = []
    private(set) var metadata: PaginationMetadata?
    private(set) var currentPage = 1
    
        // MARK: - Configuration
    let itemsPerPage: Int
    
        // MARK: - Initialization
    init(itemsPerPage: Int = 20) {
        self.itemsPerPage = itemsPerPage
    }
    
        // MARK: - Public Methods
    
        /// Carga la primera página (reemplaza resultados existentes)
    func loadInitialPage(
        from repository: NetworkRepository,
        genre: Genre? = nil
    ) async throws(NetworkError) -> MangaListResult {
        currentPage = 1
        
        let result = try await repository.getMangas(
            page: currentPage,
            perPage: itemsPerPage,
            genre: genre
        )
        
        mangas = result.mangas
        metadata = result.metadata
        
        return result
    }
    
        /// Carga la siguiente página (añade a resultados existentes)
    func loadNextPage(
        from repository: NetworkRepository,
        genre: Genre? = nil
    ) async throws(NetworkError) -> MangaListResult? {
        guard let metadata, metadata.hasMorePages else {
            return nil
        }
        
        currentPage += 1
        
        do {
            let result = try await repository.getMangas(
                page: currentPage,
                perPage: itemsPerPage,
                genre: genre
            )
            
            mangas.append(contentsOf: result.mangas)
            self.metadata = result.metadata
            
            return result
        } catch {
            currentPage -= 1  // Revertir si falla
            throw error
        }
    }
    
        /// Resetea el estado de paginación
    func reset() {
        mangas = []
        metadata = nil
        currentPage = 1
    }
    
        /// Indica si hay más páginas disponibles
    var hasMorePages: Bool {
        metadata?.hasMorePages ?? false
    }
}
