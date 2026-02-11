//
//  NetworkRepository.swift
//  myMangas
//
//  Created by Sergio García on 30/12/25.
//

import Foundation

protocol NetworkRepository: Sendable, NetworkInteractor {
    func getMangas(page: Int, perPage: Int) async throws(NetworkError) -> MangaListResult
}

struct Network: NetworkRepository {
    func getMangas(page: Int = 1, perPage: Int = 20) async throws(NetworkError) -> MangaListResult {
        try await getJSON(
            .get(url: .getMangas(page: page, per: perPage)),
            type: MangaListResponse.self
        ).toMangaListResult
    }
}

struct NetworkTest: NetworkRepository {
    func getMangas(page: Int = 1, perPage: Int = 20) async throws(NetworkError) -> MangaListResult {
        .test
    }
}

