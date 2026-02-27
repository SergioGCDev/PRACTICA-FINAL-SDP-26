//
//  NetworkInteractor.swift
//  myMangas
//
//  Created by Sergio García on 30/12/25.
//


import Foundation

/// Protocolo que proporciona un helper genérico para decodificar respuestas JSON desde una petición de red.
protocol NetworkInteractor {}

extension NetworkInteractor {
    /// Ejecuta una `URLRequest` y decodifica la respuesta JSON en el tipo `Decodable` indicado.
    func getJSON<JSON>(_ request: URLRequest, type: JSON.Type) async throws(NetworkError) -> JSON where JSON: Decodable {
        let (data, httpResponse) = try await URLSession.shared.getData(for: request)
        
        if httpResponse.statusCode == 200 {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(type, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(httpResponse.statusCode)
        }
    }
}
