//
//  MangaCollection.swift
//  Tankodex
//
//  Created by Sergio García on 23/2/26.
//

import Foundation
import SwiftData

/// Modelo persistido en SwiftData que representa un manga en la colección del usuario.
/// Almacena el progreso de lectura y estado de la colección física.
@Model
final class MangaCollection {
    /// Identificador del manga en la API.
    var mangaId: Int
    /// Título del manga.
    var title: String
    /// URL de la portada del manga.
    var coverURL: String?
    /// Número de tomos comprados por el usuario.
    var volumesBought: Int
    /// Total de volúmenes de la obra, si se conoce.
    var totalVolumes: Int?
    /// Volumen por el que va leyendo el usuario.
    var currentVolume: Int
    /// Indica si el usuario tiene la colección completa.
    var isCompleted: Bool
    /// Estado actual del manga en la colección del usuario.
    var status: ReadingStatus
    init(
        mangaId: Int,
        title: String,
        coverURL: String? = nil,
        volumesBought: Int = 0,
        totalVolumes: Int? = nil,
        currentVolume: Int = 0,
        isCompleted: Bool = false,
        status: ReadingStatus = .wishlist
    ) {
        self.mangaId = mangaId
        self.title = title
        self.coverURL = coverURL
        self.volumesBought = volumesBought
        self.totalVolumes = totalVolumes
        self.currentVolume = currentVolume
        self.isCompleted = isCompleted
        self.status = status
    }
    
    /// Convierte el modelo SwiftData a un DTO `Sendable` seguro para concurrencia.
    var toDTO: MangaCollectionDTO {
        MangaCollectionDTO(
            mangaId: mangaId,
            title: title,
            coverURL: coverURL,
            volumesBought: volumesBought,
            totalVolumes: totalVolumes,
            currentVolume: currentVolume,
            isCompleted: isCompleted,
            status: status
        )
    }
}


