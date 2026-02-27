//
//  NetworkRepository.swift
//  myMangas
//
//  Created by Sergio García on 30/12/25.
//

import Foundation

/// Protocolo que define las operaciones de red necesarias para obtener datos de mangas.
/// Cumple con `Sendable` para garantizar la seguridad en entornos concurrentes de Swift 6.
protocol NetworkRepository: Sendable, NetworkInteractor {
    
    /// Obtiene un listado de mangas paginado, con opción de filtrar por género.
    /// - Parameters:
    ///   - page: El número de página a solicitar.
    ///   - perPage: Cantidad de elementos por página.
    ///   - genre: Género opcional para filtrar los resultados.
    /// - Returns: Un objeto `MangaListResult` con los datos obtenidos.
    /// - Throws: Un error de tipo `NetworkError` si falla la petición o el decodificado.
    func getMangas(page: Int, perPage: Int, genre: Genre?) async throws(NetworkError) -> MangaListResult
    
    /// Obtiene mangas filtrados por una demografía específica.
    /// - Parameters:
    ///   - demographic: La demografía deseada (Shonen, Shojo, etc.).
    ///   - page: Número de página.
    ///   - perPage: Elementos por página.
    /// - Returns: Resultado con la lista de mangas correspondientes a la demografía.
    /// - Throws: `NetworkError` en caso de fallo en la red o datos corruptos.
    func getMangasByDemographic(demographic: Demographic, page: Int, perPage: Int) async throws(NetworkError) -> MangaListResult
    
    /// Obtiene la información detallada de un manga a través de su identificador.
    /// - Parameter id: ID único del manga.
    /// - Returns: Un objeto de tipo `Manga`.
    /// - Throws: `NetworkError` si no se encuentra el manga o hay problemas de conexión.
    func getMangaById(id: Int) async throws(NetworkError) -> Manga
    
    /// Realiza una búsqueda de mangas cuyo título contenga la cadena especificada.
    /// - Parameters:
    ///   - page: Número de página de la búsqueda.
    ///   - perPage: Resultados por página.
    ///   - titleManga: Texto a buscar en los títulos de los mangas.
    /// - Returns: Un listado de mangas que coinciden con el criterio de búsqueda.
    /// - Throws: `NetworkError` si la operación no se puede completar.
    func searchMangas(page: Int, perPage: Int, titleManga: String) async throws(NetworkError) -> MangaListResult
}

// MARK: - Convenience Methods
extension NetworkRepository {
    /// Método de conveniencia para obtener mangas sin especificar un género.
    /// - Parameters:
    ///   - page: Página a cargar (por defecto 1).
    ///   - perPage: Elementos por página (por defecto 20).
    /// - Returns: Listado de mangas paginado.
    /// - Throws: `NetworkError` en caso de error en la petición.
    func getMangas(
        page: Int = 1,
        perPage: Int = 20
    ) async throws(NetworkError) -> MangaListResult {
        try await getMangas(page: page, perPage: perPage, genre: nil)
    }
}

/// Implementación real del repositorio que conecta con la API.
struct Network: NetworkRepository {
    func getMangas(page: Int = 1, perPage: Int = 20, genre: Genre? = nil) async throws(NetworkError) -> MangaListResult {
        try await getJSON(.get(url: .getMangas(page: page, per: perPage)), type: MangaListResponse.self).toMangaListResult
    }
    
    func getMangasByDemographic(demographic: Demographic, page: Int = 1, perPage: Int = 20) async throws(NetworkError) -> MangaListResult {
        let url = URL.getMangasByDemographic(demographic, page: page, per: perPage)
        return try await getJSON(.get(url: url), type: MangaListResponse.self).toMangaListResult
    }
    
    func getMangaById(id: Int) async throws(NetworkError) -> Manga {
        try await getJSON(.get(url: .getMangaById(id)), type: MangaDTO.self).toManga
    }
    
    func searchMangas(page: Int = 1, perPage: Int = 20, titleManga: String) async throws(NetworkError) -> MangaListResult {
        let url = URL.searchMangas(page: page, per: perPage, titleManga: titleManga)
        return try await getJSON(.get(url: url), type: MangaListResponse.self).toMangaListResult
    }
}

/// Implementación de prueba (Mock) que devuelve datos estáticos para Testing o Previews de SwiftUI.
struct NetworkTest: NetworkRepository {
    func getMangas(page: Int = 1, perPage: Int = 20, genre: Genre? = nil) async throws(NetworkError) -> MangaListResult {
        .test
    }
    
    func getMangasByDemographic(demographic: Demographic, page: Int = 1, perPage: Int = 20) async throws(NetworkError) -> MangaListResult {
        .test
    }
    
    func getMangaById(id: Int) async throws(NetworkError) -> Manga {
        .test
    }
    
    func searchMangas(page: Int = 1, perPage: Int = 20, titleManga: String) async throws(NetworkError) -> MangaListResult {
        .test
    }
}
