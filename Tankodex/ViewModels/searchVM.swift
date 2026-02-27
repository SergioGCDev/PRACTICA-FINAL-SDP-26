    //
    //  SearchViewModel.swift
    //  Tankodex
    //
    //  Created by Sergio García on 10/2/26.
    //

import Foundation

/// ViewModel para la pantalla de búsqueda (`SearchView`).
/// Gestiona búsqueda por texto, filtros por demografía y paginación infinita.
@MainActor
@Observable
final class searchVM {
    
    // MARK: - Dependencies
    
    private let repository: NetworkRepository
    
    // MARK: - State
    
    /// Indica si hay una operación de carga en curso.
    private(set) var isLoading = false
    /// Mensaje de error si la última operación falló.
    private(set) var errorMessage: String?
    /// Resultados de búsqueda directa por texto (no paginados).
    private(set) var searchResults: [Manga] = []
    
    // MARK: - Filters
    
    /// Género activo como filtro, si existe.
    private(set) var filteredGenre: Genre?
    /// Demografía activa como filtro. Por defecto `.all`.
    private(set) var filteredDemographic: Demographic = .all
    /// Texto de búsqueda introducido por el usuario.
    var searchText: String = ""
    
    // MARK: - Pagination
    
    private let pagination = PaginationController(itemsPerPage: 20)
    
    // MARK: - Initialization
    
    /// - Parameter repository: Repositorio de red. Por defecto usa `Network()`.
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }
    
    // MARK: - Computed Properties
    
    /// Lista de mangas cargados por el paginador.
    var mangas: [Manga] { pagination.mangas }
    
    /// Metadatos de paginación de la última respuesta.
    var metadata: PaginationMetadata? { pagination.metadata }
    
    /// Mangas filtrados según el texto de búsqueda y la demografía activa.
    /// Si el texto tiene menos de 3 caracteres, filtra solo por demografía.
    var filteredMangas: [Manga] {
        if filteredDemographic == .all { return pagination.mangas }
        return pagination.mangas.filter { $0.demographics.contains(filteredDemographic) }
    }
    
    // MARK: - Public Methods
    
    /// Cambia el filtro de demografía, resetea la paginación y recarga.
    /// - Parameter demographic: Nueva demografía a aplicar.
    func filterByDemographic(_ demographic: Demographic) {
        filteredDemographic = demographic
        pagination.reset()
        Task { await loadMangas() }
    }
    
    /// Carga la primera página según los filtros activos.
    func loadMangas() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            _ = try await pagination.loadInitialPage(
                from: repository,
                demographic: filteredDemographic == .all ? nil : filteredDemographic,
                searchQuery: searchText.count >= 3 ? searchText : nil
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    /// Carga la siguiente página según los filtros activos y la añade a la lista.
    func loadNextPage() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            _ = try await pagination.loadNextPage(
                from: repository,
                demographic: filteredDemographic == .all ? nil : filteredDemographic,
                searchQuery: searchText.count >= 3 ? searchText : nil
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    /// Carga la siguiente página si el manga recibido es el último de la lista.
    /// Usado para implementar infinite scroll.
    /// - Parameter manga: Manga que acaba de aparecer en pantalla.
    func loadNextPageIfNeeded(manga: Manga) async {
        guard manga.id == pagination.mangas.last?.id else { return }
        await loadNextPage()
    }
    
    /// Resetea la paginación y recarga desde la primera página.
    func retry() async {
        pagination.reset()
        await loadMangas()
    }
    
    /// Llamado cuando el texto de búsqueda cambia con 3+ caracteres o se vacía.
    /// Resetea la paginación y lanza una nueva búsqueda.
    func onSearchTextChanged() {
        pagination.reset()
        Task { await loadMangas() }
    }
    
// MARK: - Display Logic
    
    /// Devuelve los géneros a mostrar para un manga, priorizando el filtro activo.
    /// - Parameters:
    /// - manga: Manga del que obtener los géneros.
    /// - limit: Número máximo de géneros a mostrar. Por defecto 3.
    func displayGenres(for manga: Manga, limit: Int = 3) -> [Genre] {
        guard let filteredGenre else { return Array(manga.genres.prefix(limit)) }
        var result: [Genre] = []
        if manga.genres.contains(filteredGenre) { result.append(filteredGenre) }
        let remaining = manga.genres.filter { $0 != filteredGenre }
        result.append(contentsOf: remaining.prefix(limit - result.count))
        return result
    }
}
