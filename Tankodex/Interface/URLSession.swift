//
//  URLSession.swift
//  EmpleadosAPI
//
//  Created by Sergio García on 19/11/25.
//

import Foundation

// TODO: Revisar clase #27 3:25:00 -> 3:36:00 (Revisar toda la capa de Interface(Red) + Repository.
//extension URLSession {
//    func getData(for request: URLRequest) async throws(NetworkError) -> (data: Data, response: HTTPURLResponse) {
//        do {
//            let (data, response) = try await URLSession.shared.data(for: .get(url: .getFilms)) // Llamamos al arhivo URLRequest
//            guard let httpResponse = response as? HTTPURLResponse else {
//                throw NetworkError.nonHTTP
//            }
//            return (data, httpResponse)
//        } catch {
//            throw .general(error)
//        }
//    }
//}

extension URLSession {
    func getData(for request: URLRequest) async throws(NetworkError) -> (data: Data, response: HTTPURLResponse) {
        do {
            // ✅ Usar el request que recibimos como parámetro
            let (data, response) = try await data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.nonHTTP
            }
            return (data, httpResponse)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw .general(error)
        }
    }
}
