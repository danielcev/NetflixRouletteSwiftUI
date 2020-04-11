//
//  ContentAPI.swift
//  NetflixRoulette
//
//  Created by Daniel Plata on 11/04/2020.
//  Copyright © 2020 silverapps. All rights reserved.
//

import Foundation

import Foundation
import Combine

protocol ContentProvider {
    func getRandomContent() -> AnyPublisher<ContentResponse, APIError>
    func getImage(id: String) -> AnyPublisher<Data, APIError>
}

class ContentApi: ContentProvider {
    private enum Endpoint: String {
        case randomContent = "https://api.reelgood.com/roulette?content_kind=movie&free=false&nocache=true&sources=netflix"
        case imageContent = "https://img.reelgood.com/content/movie/"
    }
    private enum Method: String {
        case GET
    }

    init() {}

    func getRandomContent() -> AnyPublisher<ContentResponse, APIError> {
        return call(.randomContent, method: .GET)
    }

    func getImage(id: String) -> AnyPublisher<Data, APIError> {
        return call("\(Endpoint.imageContent.rawValue)\(id)/poster-342.jpg", method: .GET)
    }

    private func call<T: Decodable>(_ endPoint: Endpoint, method: Method) -> AnyPublisher<T, APIError> {
        let urlRequest = request(for: endPoint.rawValue, method: method)

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError{ _ in APIError.serverError }
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in APIError.parsingError }
            .eraseToAnyPublisher()
    }

    private func call(_ endPoint: String, method: Method) -> AnyPublisher<Data, APIError> {
        let urlRequest = request(for: endPoint, method: method)

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError{ _ in APIError.serverError }
            .map { $0.data }
            .eraseToAnyPublisher()
    }

    private func request(for endpoint: String, method: Method) -> URLRequest {
        guard let url = URL(string: endpoint)
            else { preconditionFailure("Bad URL") }

        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        return request
    }
}

