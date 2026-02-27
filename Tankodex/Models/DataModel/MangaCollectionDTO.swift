    //
    //  MangaCollectionDTO.swift
    //  Tankodex
    //
    //  Created by Sergio García on 23/2/26.
    //

import Foundation


    /// DTO inmutable y `Sendable` de ``MangaCollection``.
    /// Usado para pasar datos de la colección entre contextos de concurrencia de forma segura.
struct MangaCollectionDTO: Identifiable, Sendable {
    /// Identificador del manga en la API.
    let mangaId: Int
    /// Título del manga.
    let title: String
    /// URL de la portada.
    let coverURL: String?
    /// Número de tomos comprados.
    let volumesBought: Int
    /// Total de volúmenes de la obra.
    let totalVolumes: Int?
    /// Volumen actual de lectura.
    let currentVolume: Int
    /// Indica si la colección está completa.
    let isCompleted: Bool
    /// Estado del manga en la colección.
    let status: ReadingStatus
    
    /// Identificador único requerido por `Identifiable`. Alias de `mangaId`.
    var id: Int { mangaId }
}
