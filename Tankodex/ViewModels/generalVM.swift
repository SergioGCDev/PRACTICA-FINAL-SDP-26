//
//  MangaListViewModel.swift
//  Tankodex
//
//  Created by Sergio García on 10/2/26.
//

import Foundation

/// ViewModel principal para la pantalla de noticias (`NewsView`).
/// Gestiona la carga y paginación de mangas destacados y recientes.
@MainActor
@Observable
final class generalVM {
    
    // MARK: - State
    
    /// Indica si hay una operación de carga en curso.
    private(set) var isLoading = false
    /// Mensaje de error si la última operación falló.
    private(set) var errorMessage: String?
    /// Top 5 mangas ordenados por puntuación.
    private(set) var topFiveMangas: [Manga] = []
    /// Top 10 mangas ordenados por puntuación.
    private(set) var topTenMangas: [Manga] = []
    /// Últimos 10 mangas ordenados por fecha de inicio.
    private(set) var recentMangas: [Manga] = []
    
    // MARK: - Pagination
    
    private let pagination = PaginationController(itemsPerPage: 20)
    
    // MARK: - Dependencies
    
    private let repository: NetworkRepository
    
    // MARK: - Initialization
    
    /// - Parameter repository: Repositorio de red. Por defecto usa `Network()`.
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }
    
    // MARK: - Computed Properties
    
    /// Lista completa de mangas cargados por el paginador.
    var mangas: [Manga] { pagination.mangas }
    
    /// Metadatos de paginación de la última respuesta.
    var metadata: PaginationMetadata? { pagination.metadata }
    
    // MARK: - Public Methods
    
    /// Carga la primera página de mangas y calcula los rankings y recientes.
    func loadMangas() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            _ = try await pagination.loadInitialPage(from: repository)
            let sortedByScore = pagination.mangas.sorted { $0.score > $1.score }
            topFiveMangas = Array(sortedByScore.prefix(5))
            topTenMangas = Array(sortedByScore.prefix(10))
            recentMangas = pagination.mangas
                .filter { $0.startDate != nil }
                .sorted { $0.startDate! > $1.startDate! }
                .prefix(10)
                .map { $0 }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    /// Carga la siguiente página de mangas y la añade a la lista existente.
    func loadNextPage() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            _ = try await pagination.loadNextPage(from: repository)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    /// Resetea la paginación y recarga desde la primera página.
    func retry() async {
        pagination.reset()
        await loadMangas()
    }
}
