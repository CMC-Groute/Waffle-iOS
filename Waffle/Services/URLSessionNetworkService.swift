//
//  URLSessionNetworkService.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import Combine

enum NetworkErrors: LocalizedError {
    case invalidURL
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        }
    }
}

class URLSessionNetworkService: URLSessionNetworkServiceProtocol {
    
    static let shared: URLSessionNetworkService = URLSessionNetworkService()
    
    private let session: URLSession = .shared
    private let decoder: JSONDecoder = JSONDecoder()
    
    init() {}
    
    func request(_ urlRequest: NetworkRequestBuilder) -> AnyPublisher<Data, Error> {
        guard let urlRequest = urlRequest.urlRequest else {
            return Fail(error: NetworkErrors.invalidURL).eraseToAnyPublisher()
        }
        return self.session.dataTaskPublisher(for: urlRequest)
            
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    switch (response as? HTTPURLResponse)?.statusCode {
                    case .some(404):
                        throw URLError(.cannotFindHost)
                    default:
                        throw URLError(.badServerResponse)
                    }
                }
                
                return data
            }
            .eraseToAnyPublisher()
    }
    
    func request<T: Decodable>(_ urlRequest: NetworkRequestBuilder, responseType: T.Type) -> AnyPublisher<T, Error> {
        return request(urlRequest)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func defaultRequest(_ urlRequest: NetworkRequestBuilder) -> AnyPublisher<DefaultResponse, Error> {
        print("urlSession defaultRequest")
        return request(urlRequest)
            .decode(type: DefaultResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func request(_ urlRequest: NetworkRequestBuilder) -> AnyPublisher<[[String: Any]], Error> {
        return request(urlRequest)
            .tryCompactMap { return try JSONSerialization.jsonObject(with: $0, options: []) as? [[String: Any]] }
            .eraseToAnyPublisher()
    }
    
    func request(_ urlRequest: NetworkRequestBuilder) -> AnyPublisher<[String: Any], Error> {
        return request(urlRequest)
            .tryCompactMap { return try JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
            .eraseToAnyPublisher()
    }
}

struct DefaultResponse: Codable {
    var message: String
    var data: String
}
