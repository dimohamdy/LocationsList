//
//  APIClient.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation
import UIKit

// MARK: - URLSession
protocol URLSessionProtocol {
    func data(with url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    func data(with url: URL) async throws -> (Data, URLResponse) {
        return try await data(from: url)
    }
}

final class APIClient {
    private var session: URLSessionProtocol
    init(withSession session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func loadData<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await session.data(with: url)
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
            throw LocationsListError.invalidServerResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
