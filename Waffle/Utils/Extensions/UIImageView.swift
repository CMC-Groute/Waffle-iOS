//
//  UIImageView.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit

extension UIImageView {
    func setImageWith(url: URL?) {
        guard let url = url else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        
        if let cachedData = ImageFileManager.shared.cachedData(request: request) {
            self.setImageWith(data: cachedData)
            return
        }else {
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard error == nil else { return }
                guard let self = self, let data = data, let response = response else { return }
                
                ImageFileManager.shared.saveToCache(request: request, reponse: response, data: data)
                self.setImageWith(data: data)
                return
            }.resume()
        }
    }
    
    private func setImageWith(data: Data) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.image = UIImage(data: data)
        }
    }
}
