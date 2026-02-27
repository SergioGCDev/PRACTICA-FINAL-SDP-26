    //
    //  LibraryViewModel.swift
    //  Tankodex
    //
    //  Created by Sergio García on 23/2/26.
    //

import Foundation
import SwiftData

/// ViewModel para la gestión de la colección del usuario (`LibraryView`).
/// Coordina las operaciones de lectura y escritura sobre `DataContainer`.
@MainActor
@Observable
final class libraryVM {
    
    // MARK: - State
    
    /// Colección actual del usuario como array de DTOs.
    private(set) var collection: [MangaCollectionDTO] = []
    /// Indica si hay una operación en curso.
    private(set) var isLoading = false
    /// Mensaje de error si la última operación falló.
    private(set) var errorMessage: String?
    
    // MARK: - Dependencies
    private let dataContainer: DataContainer
    private let repository: NetworkRepository
    
    // MARK: - Initialization
    /// - Parameters:
    /// - modelContainer: Contenedor de SwiftData.
    /// - repository: Repositorio de red. Por defecto usa `Network()`.
    init(modelContainer: ModelContainer, repository: NetworkRepository = Network()) {
        self.dataContainer = DataContainer(modelContainer: modelContainer)
        self.repository = repository
    }
    
    // MARK: - Computed Properties
    
    /// Colección agrupada por estado de lectura.
    var byStatus: [ReadingStatus: [MangaCollectionDTO]] {
        Dictionary(grouping: collection, by: \.status)
    }
    
    /// Total de mangas en la colección.
    var totalMangas: Int { collection.count }
    
    /// Total de tomos comprados sumando todos los mangas de la colección.
    var totalVolumesOwned: Int {
        collection.reduce(0) { $0 + $1.volumesBought }
    }
    
    // MARK: - Public Methods
    
    /// Carga toda la colección del usuario desde SwiftData.
    func loadCollection() async {
        isLoading = true
        errorMessage = nil
        do {
            collection = try await dataContainer.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    /// Añade un manga a la colección con el estado indicado.
    /// - Parameters:
    /// - manga: Manga a añadir.
    /// - status: Estado inicial en la colección.
    func addManga(_ manga: Manga, status: ReadingStatus) async {
        do {
            try await dataContainer.addManga(manga, status: status)
            await loadCollection()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Elimina un manga de la colección.
    /// - Parameter manga: Manga a eliminar.
    func removeManga(_ manga: Manga) async {
        do {
            try await dataContainer.removeManga(mangaId: manga.id)
            collection.removeAll { $0.mangaId == manga.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Actualiza el estado de lectura de un manga en la colección.
    /// - Parameters:
    /// - manga: Manga a actualizar.
    /// - status: Nuevo estado de lectura.
    func updateStatus(_ manga: Manga, status: ReadingStatus) async {
        do {
            try await dataContainer.updateStatus(mangaId: manga.id, status: status)
            await loadCollection()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Comprueba si un manga está en la colección consultando SwiftData directamente.
    /// - Parameter manga: Manga a comprobar.
    func isInLibrary(_ manga: Manga) async -> Bool {
        (try? await dataContainer.isInLibrary(mangaId: manga.id)) ?? false
    }
    
    /// Comprueba si un manga está en la colección en memoria (sin I/O).
    /// - Parameter manga: Manga a comprobar.
    func isInLibrary(_ manga: Manga) -> Bool {
        collection.contains { $0.mangaId == manga.id }
    }
    
    /// Guarda los cambios de progreso y estado de un manga en la colección.
    /// - Parameters:
    /// - manga: Manga a actualizar.
    /// - volumesBought: Tomos comprados.
    /// - currentVolume: Tomo actual de lectura.
    /// - isCompleted: Si la colección está completa.
    /// - status: Estado de lectura.
    func saveCollection(manga: Manga, volumesBought: Int, currentVolume: Int, isCompleted: Bool, status: ReadingStatus) async {
        do {
            try await dataContainer.updateProgress(
                mangaId: manga.id,
                volumesBought: volumesBought,
                currentVolume: currentVolume,
                isCompleted: isCompleted
            )
            try await dataContainer.updateStatus(mangaId: manga.id, status: status)
            await loadCollection()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Carga un manga completo desde la API por su ID.
    /// Usado para abrir `MangaDetailView` desde `LibraryView`.
    /// - Parameter id: ID del manga en la API.
    /// - Returns: `Manga` si se encontró, `nil` si hubo error.
    func loadManga(id: Int) async -> Manga? {
        do {
            return try await repository.getMangaById(id: id)
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
    
    /// Resuelve el estado correcto según el volumen actual y el total de volúmenes.
    /// Si el usuario ha completado todos los volúmenes en modo `.collected`, devuelve `.completed`.
    /// - Parameters:
    /// - currentVolume: Volumen actual de lectura.
    /// - totalVolumes: Total de volúmenes de la obra.
    /// - status: Estado actual.
    func resolveStatus(currentVolume: Int, totalVolumes: Int?, status: ReadingStatus) -> ReadingStatus {
        guard let total = totalVolumes else { return status }
        if currentVolume == total && status == .collected { return .completed }
        return status
    }
    
    /// Número de mangas en la colección con el estado indicado.
    /// - Parameter status: Estado de lectura a filtrar.
    func count(for status: ReadingStatus) -> Int {
        collection.filter { $0.status == status }.count
    }
}
