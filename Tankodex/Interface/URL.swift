//
//  URL.swift
//  myMangas
//
//  Created by Sergio García on 30/12/25.
//


import Foundation

/// URL base de la API para el proyecto myMangas.
let api = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!

// MARK: - API Endpoints
extension URL {
    
    /// Genera la URL para obtener el listado de los mejores mangas paginado.
    /// - Parameters:
    ///   - page: El número de página que se desea solicitar. Por defecto es 1.
    ///   - per: La cantidad de elementos por página. Por defecto es 20.
    /// - Returns: Una `URL` configurada con el endpoint de mejores mangas y los parámetros de consulta.
    static func getMangas(page: Int = 1, per: Int = 20) -> URL {
        api.appending(path: "/list/bestMangas")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(per)")
            ])
    }
    
    /// Genera la URL para filtrar mangas por su demografía (Shonen, Shojo, etc.).
    /// - Parameters:
    ///   - demographic: El tipo de demografía por el cual filtrar.
    ///   - page: El número de página solicitado. Por defecto es 1.
    ///   - per: Cantidad de resultados por página. Por defecto es 20.
    /// - Returns: Una `URL` que apunta al recurso de mangas por demografía específica.
    static func getMangasByDemographic(_ demographic: Demographic, page: Int = 1, per: Int = 20) -> URL {
        api.appending(path: "/list/mangaByDemographic/\(demographic.rawValue)")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(per)")
            ])
    }
    
    /// Genera la URL para obtener el detalle de un manga específico mediante su identificador.
    /// - Parameter id: El ID único del manga en la base de datos.
    /// - Returns: Una `URL` para consultar un único manga.
    static func getMangaById(_ id: Int) -> URL {
        api.appending(path: "search/manga/\(id)")
    }
    
    /// Genera la URL para realizar una búsqueda de mangas que contengan una cadena de texto en el título.
    /// - Parameters:
    ///   - page: El número de página solicitado. Por defecto es 1.
    ///   - per: Cantidad de resultados por página. Por defecto es 20.
    ///   - titleManga: El texto o título parcial que se desea buscar.
    /// - Returns: Una `URL` configurada para la búsqueda por título con paginación.
    static func searchMangas(page: Int = 1, per: Int = 20, titleManga: String) -> URL {
        api.appending(path: "search/mangasContains/\(titleManga)")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(per)")
            ])
    }
}
