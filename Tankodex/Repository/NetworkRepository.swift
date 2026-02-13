    //
    //  NetworkRepository.swift
    //  myMangas
    //
    //  Created by Sergio García on 30/12/25.
    //

import Foundation

protocol NetworkRepository: Sendable, NetworkInteractor {
    func getMangas(
        page: Int,
        perPage: Int,
        genre: Genre?
    ) async throws(NetworkError) -> MangaListResult
    
}

    // MARK: - Convenience Methods
extension NetworkRepository {
    func getMangas(
        page: Int = 1,
        perPage: Int = 20
    ) async throws(NetworkError) -> MangaListResult {
        try await getMangas(page: page, perPage: perPage, genre: nil)
    }
}


struct Network: NetworkRepository {
    func getMangas(
        page: Int = 1,
        perPage: Int = 20,
        genre: Genre? = nil
    ) async throws(NetworkError) -> MangaListResult {
        try await getJSON(
            .get(url: .getMangas(page: page, per: perPage)),
            type: MangaListResponse.self
        ).toMangaListResult
    }
}

struct NetworkTest: NetworkRepository {
    func getMangas(
        page: Int = 1,
        perPage: Int = 20,
        genre: Genre? = nil
    ) async throws(NetworkError) -> MangaListResult {
        .test
    }
}

