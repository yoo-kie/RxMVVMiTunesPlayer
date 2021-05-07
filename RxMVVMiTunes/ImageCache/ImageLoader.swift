//
//  ImageLoader.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/05/07.
//

import UIKit

final class ImageLoader {
    
    private var task: URLSessionTask?
    
    func fetchImage(with url: String, completion: @escaping (Result<UIImage, ImageError>) -> Void) {
        let cacheKey: NSString = NSString(string: url)
        
        if let image = ImageCache.instance.cache.object(forKey: cacheKey) {
            completion(.success(image))
        }
        
        let session = URLSession(configuration: .default)
        
        guard let url = URL(string: url) else {
            completion(.failure(.URLError))
            return
        }
        
        task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.ResponseError))
                return
            }
            
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(.success(image))
                    ImageCache.instance.cache.setObject(image, forKey: cacheKey)
                }
            }
        }
        
        guard let task = task else { return }

        task.resume()
    }
    
    func cancelTask() {
        guard let task = task else { return }
        task.cancel()
    }
    
}
