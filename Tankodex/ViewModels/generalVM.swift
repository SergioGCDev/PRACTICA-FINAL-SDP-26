    //
    //  MangaListViewModel.swift
    //  Tankodex
    //
    //  Created by Sergio García on 10/2/26.
    //

import Foundation

@MainActor
@Observable
final class generalVM {
        // MARK: - State
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
        // MARK: - Pagination
    private let pagination = PaginationController(itemsPerPage: 20)  // ← USAR controlador
    
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
    
    var topFiveMangas: [Manga] {
        mangas
            .sorted { $0.score > $1.score }
            .prefix(5)
            .map { $0 }
    }
    
    var recentMangas: [Manga] {
        mangas
            .filter { $0.startDate != nil }
            .sorted { $0.startDate! > $1.startDate! }
            .prefix(10)
            .map { $0 }
    }
    
        // MARK: - Public Methods
    
    func loadMangas() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await pagination.loadInitialPage(from: repository)
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
            _ = try await pagination.loadNextPage(from: repository)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func retry() async {
        pagination.reset()
        await loadMangas()
    }
}


// Testing
//func testPaginationController() async throws {
//    let controller = PaginationController()
//    let repo = NetworkTest()
//    
//    _ = try await controller.loadInitialPage(from: repo)
//    XCTAssertEqual(controller.mangas.count, 5)
//    
//    _ = try await controller.loadNextPage(from: repo)
//    XCTAssertEqual(controller.mangas.count, 10)
//}
