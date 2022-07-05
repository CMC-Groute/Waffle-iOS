//
//  Encodable.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/02.
//

import Foundation

struct JSON {
    static let encoder = JSONEncoder()
    
    static func decode<T: Decodable>(data: Data, to target: T.Type) -> T? {
        return try? JSONDecoder().decode(target, from: data)
    }
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}

