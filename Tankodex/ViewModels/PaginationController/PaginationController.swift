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
    
    /// Listado de mangas obtenidos de la API. Se actualiza al cargar nuevas páginas.
    private(set) var mangas: [Manga] = []
    /// Información de paginación actual (total de páginas, registros, etc.).
    private(set) var metadata: PaginationMetadata?
    /// El número de página actual que se está visualizando o cargando.
    private(set) var currentPage = 1
    
    // MARK: - Configuration
    
    /// Cantidad de elementos que se solicitan en cada petición a la red.
    let itemsPerPage: Int
    
    // MARK: - Initialization
    
    init(itemsPerPage: Int = 20) {
        self.itemsPerPage = itemsPerPage
    }
    
    // MARK: - Public Methods
    
    /// Carga la primera página (reemplaza resultados existentes)
    func loadInitialPage(
        from repository: NetworkRepository,
        genre: Genre? = nil,
        demographic: Demographic? = nil,
        searchQuery: String? = nil
    ) async throws(NetworkError) -> MangaListResult {
        currentPage = 1
        
        let result: MangaListResult
        
        if let searchQuery {
            result = try await repository.searchMangas(
                page: currentPage,
                perPage: itemsPerPage,
                titleManga: searchQuery
            )
        } else if let demographic {
            result = try await repository.getMangasByDemographic(
                demographic: demographic,
                page: currentPage,
                perPage: itemsPerPage
            )
        } else {
            result = try await repository.getMangas(
                page: currentPage,
                perPage: itemsPerPage,
                genre: genre
            )
        }
        
        mangas = result.mangas
        metadata = result.metadata
        
        return result
    }
    
    /// Carga la siguiente página (añade a resultados existentes)
    func loadNextPage(
        from repository: NetworkRepository,
        genre: Genre? = nil,
        demographic: Demographic? = nil,
        searchQuery: String? = nil
    ) async throws(NetworkError) -> MangaListResult? {
        guard let metadata, metadata.hasMorePages else {
            return nil
        }
        
        currentPage += 1
        
        do {
            let result: MangaListResult
            
            if let searchQuery {
                result = try await repository.searchMangas(
                    page: currentPage,
                    perPage: itemsPerPage,
                    titleManga: searchQuery
                )
            } else if let demographic {
                result = try await repository.getMangasByDemographic(
                    demographic: demographic,
                    page: currentPage,
                    perPage: itemsPerPage
                )
            } else {
                result = try await repository.getMangas(
                    page: currentPage,
                    perPage: itemsPerPage,
                    genre: genre
                )
            }
            
            mangas.append(contentsOf: result.mangas)
            self.metadata = result.metadata
            
            return result
        } catch {
            currentPage -= 1
            throw error
        }
    }
    
    
    
    /// Resetea el estado de paginación
    func reset() {
        print("🔄 PaginationController reset - caller: \(Thread.callStackSymbols[1])")
        mangas = []
        metadata = nil
        currentPage = 1
    }
    
    /// Indica si hay más páginas disponibles
    var hasMorePages: Bool {
        metadata?.hasMorePages ?? false
    }
}
