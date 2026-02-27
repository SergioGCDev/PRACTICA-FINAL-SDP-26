//
//  DataContainer.swift
//  Tankodex
//
//  Created by Sergio García on 23/2/26.
//

import Foundation
import SwiftData

/// Actor de SwiftData que centraliza las operaciones CRUD sobre la colección de manga del usuario.
@ModelActor
actor DataContainer {

    // MARK: - Create

    /// Inserta un manga en la biblioteca con el estado de lectura indicado, ignorándolo si ya existe.
    func addManga(_ manga: Manga, status: ReadingStatus) throws {
        let mangaId = manga.id
        let descriptor = FetchDescriptor<MangaCollection>(
            predicate: #Predicate { $0.mangaId == mangaId }
            // Comprobamos si existe en SwiftData el manga para no insertarlo de nuevo.
        )
        let existing = try modelContext.fetch(descriptor)
        guard existing.isEmpty else { return }
        
        let entry = MangaCollection(
            mangaId: manga.id,
            title: manga.title,
            coverURL: manga.mainPicture?.absoluteString,
            totalVolumes: manga.volumes,
            status: status
        )
        modelContext.insert(entry)
        try modelContext.save()
    }
    
    // MARK: - Read

    /// Devuelve todos los mangas de la biblioteca ordenados por título.
    func fetchAll() throws -> [MangaCollectionDTO] {
        let descriptor = FetchDescriptor<MangaCollection>(
            sortBy: [SortDescriptor(\.title)]
        )
        return try modelContext.fetch(descriptor).map(\.toDTO)
    }

    /// Devuelve los mangas filtrados por el estado de lectura indicado, ordenados por título.
    func fetchByStatus(_ status: ReadingStatus) throws -> [MangaCollectionDTO] {
        let descriptor = FetchDescriptor<MangaCollection>(
            predicate: #Predicate { $0.status == status },
            sortBy: [SortDescriptor(\.title)]
        )
        return try modelContext.fetch(descriptor).map(\.toDTO)
    }
    
    /// Indica si un manga con el identificador dado ya está guardado en la biblioteca.
    func isInLibrary(mangaId: Int) throws -> Bool {
        let descriptor = FetchDescriptor<MangaCollection>(
            predicate: #Predicate { $0.mangaId == mangaId }
        )
        return try !modelContext.fetch(descriptor).isEmpty
    }
    
    // MARK: - Update

    /// Actualiza el estado de lectura de un manga existente en la biblioteca.
    func updateStatus(mangaId: Int, status: ReadingStatus) throws {
        let descriptor = FetchDescriptor<MangaCollection>(
            predicate: #Predicate { $0.mangaId == mangaId }
        )
        guard let entry = try modelContext.fetch(descriptor).first else { return }
        entry.status = status
        try modelContext.save()
    }
    
    /// Actualiza los datos de progreso de lectura y colección de un manga.
    func updateProgress(mangaId: Int, volumesBought: Int, currentVolume: Int, isCompleted: Bool) throws {
        let descriptor = FetchDescriptor<MangaCollection>(
            predicate: #Predicate { $0.mangaId == mangaId }
        )
        guard let entry = try modelContext.fetch(descriptor).first else { return }
        entry.volumesBought = volumesBought
        entry.currentVolume = currentVolume
        entry.isCompleted = isCompleted
        try modelContext.save()
    }
    
    // MARK: - Delete

    /// Elimina de la biblioteca el manga con el identificador dado.
    func removeManga(mangaId: Int) throws {
        let descriptor = FetchDescriptor<MangaCollection>(
            predicate: #Predicate { $0.mangaId == mangaId }
        )
        guard let entry = try modelContext.fetch(descriptor).first else { return }
        modelContext.delete(entry)
        try modelContext.save()
    }
}
