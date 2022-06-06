//
//  URLSessionNetworkServiceProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import Combine

protocol URLSessionNetworkServiceProtocol {
    func request(_ urlRequest: NetworkRequestBuilder) -> AnyPublisher<Data, Error>
    func request<T: Decodable>(_ urlRequest: NetworkRequestBuilder) -> AnyPublisher<T, Error>
    func request(_ urlRequest: NetworkRequestBuilder) -> AnyPublisher<[[String: Any]], Error>
    func request(_ urlRequest: NetworkRequestBuilder) -> AnyPublisher<[String: Any], Error>
}
