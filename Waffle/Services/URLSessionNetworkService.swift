//
//  URLSessionNetworkService.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import RxSwift
import RxCocoa

enum URLSessionNetworkServiceError: Int, Error, CustomStringConvertible {
    var description: String { self.errorDescription }
    
    case emptyDataError
    case responseDecodingError
    case payloadEncodingError
    case unknownError
    case invalidURLError
    case invalidRequestError = 400
    case authenticationError = 401
    case forbiddenError = 403
    case notFoundError = 404
    case notAllowedHTTPMethodError = 405
    case timeoutError = 408
    case internalServerError = 500
    case notSupportedError = 501
    case badGatewayError = 502
    case invalidServiceError = 503
    
    var errorDescription: String {
        switch self {
        case .invalidURLError: return "INVALID_URL_ERROR"
        case .invalidRequestError: return "400:INVALID_REQUEST_ERROR"
        case .authenticationError: return "401:AUTHENTICATION_FAILURE_ERROR"
        case .forbiddenError: return "403:FORBIDDEN_ERROR"
        case .notFoundError: return "404:NOT_FOUND_ERROR"
        case .notAllowedHTTPMethodError: return "405:NOT_ALLOWED_HTTP_METHOD_ERROR"
        case .timeoutError: return "408:TIMEOUT_ERROR"
        case .internalServerError: return "500:INTERNAL_SERVER_ERROR"
        case .notSupportedError: return "501:NOT_SUPPORTED_ERROR"
        case .badGatewayError: return "502:BAD_GATEWAY_ERROR"
        case .invalidServiceError: return "503:INVALID_SERVICE_ERROR"
        case .responseDecodingError: return "RESPONSE_DECODING_ERROR"
        case .payloadEncodingError: return "REQUEST_BODY_ENCODING_ERROR"
        case .unknownError: return "UNKNOWN_ERROR"
        case .emptyDataError: return "RESPONSE_DATA_EMPTY_ERROR"
        }
    }
}


class URLSessionNetworkService {
    
    static let shared: URLSessionNetworkService = URLSessionNetworkService()
    
    private let session: URLSession = .shared
    private let decoder: JSONDecoder = JSONDecoder()
    
    init() {}
    
    func request(_ urlRequest: NetworkRequestBuilder) -> Observable<Result<Data, URLSessionNetworkServiceError>> {
        guard let urlRequest = urlRequest.urlRequest else {
            return .just(.failure(URLSessionNetworkServiceError.invalidURLError))
        }
        return Observable<Result<Data, URLSessionNetworkServiceError>>.create { emitter in
            print(urlRequest.allHTTPHeaderFields)
            let task = URLSession.shared.dataTask(with: urlRequest) { data, reponse, error in
                guard let httpResponse = reponse as? HTTPURLResponse else {
                    emitter.onError(URLSessionNetworkServiceError.unknownError)
                    return
                }
                if error != nil {
                    emitter.onError(self.configureHTTPError(errorCode: httpResponse.statusCode))
                    return
                }
                guard 200...299 ~= httpResponse.statusCode else {
                    print("httpResponse.statusCode \(httpResponse.statusCode)")
                    emitter.onError(self.configureHTTPError(errorCode: httpResponse.statusCode))
                    return
                }
                guard let data = data else {
                    print("httpResponse. emptyDataError")
                    emitter.onNext(.failure(.emptyDataError))
                    return
                }
                emitter.onNext(.success(data))
                emitter.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
//    func request<T: Decodable>(_ urlRequest: NetworkRequestBuilder, responseType: T.Type) -> AnyPublisher<T, Error> {
//        return request(urlRequest)
//            .decode(type: T.self, decoder: decoder)
//            .eraseToAnyPublisher()
//    }
//
//    func defaultRequest(_ urlRequest: NetworkRequestBuilder) -> AnyPublisher<DefaultResponse, Error> {
//        print("urlSession defaultRequest")
//        return request(urlRequest)
//            .decode(type: DefaultResponse.self, decoder: decoder)
//            .eraseToAnyPublisher()
//    }
//
//    func request(_ urlRequest: NetworkRequestBuilder) -> AnyPublisher<[[String: Any]], Error> {
//        return request(urlRequest)
//            .tryCompactMap { return try JSONSerialization.jsonObject(with: $0, options: []) as? [[String: Any]] }
//            .eraseToAnyPublisher()
//    }
//
//    func request(_ urlRequest: NetworkRequestBuilder) -> AnyPublisher<[String: Any], Error> {
//        return request(urlRequest)
//            .tryCompactMap { return try JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
//            .eraseToAnyPublisher()
//    }
    
    private func configureHTTPError(errorCode: Int) -> Error {
        return URLSessionNetworkServiceError(rawValue: errorCode)
        ?? URLSessionNetworkServiceError.unknownError
    }
}
