//
//  ImageFielManager.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import Foundation

final class ImageFileManager {
    private let fileManager: FileManager
    private let cache: URLCache
    
    static let shared = ImageFileManager(fileManager: FileManager.default)
    
    private init(fileManager: FileManager) {
        self.fileManager = fileManager
        let cacheURL = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        let diskCacheURL = cacheURL?.appendingPathComponent("DownloadCache")
        cache = .init(memoryCapacity: 0, diskCapacity: 10_000_000, directory: diskCacheURL)
    }
    
    func cachedData(request: URLRequest) -> Data? {
        self.cache.cachedResponse(for: request)?.data
    }
    
    func saveToCache(request: URLRequest, reponse: URLResponse, data: Data) {
        self.cache.storeCachedResponse(CachedURLResponse(response: reponse, data: data), for: request)
    }
}
