//
//  ImageCacheManager.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import UIKit
import RxSwift
import RxCocoa

final class ImageManager {
    
    static let instance = ImageManager()
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    private var imageUrl: String?
    
    func fetchImage(with url: String, completion: @escaping (Result<UIImage, ImageError>) -> Void) {
        let cacheKey: NSString = NSString(string: url)
        
        imageUrl = url
        
        if let image = ImageManager.instance.cache.object(forKey: cacheKey) {
            completion(.success(image))
        }
        
        let session = URLSession(configuration: .default)
        
        guard let url = URL(string: url) else {
            completion(.failure(.URLError))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.ResponseError))
                return
            }
            
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    if self.imageUrl == url.absoluteString {
                        completion(.success(image))
                    }
                    
                    ImageManager.instance.cache.setObject(image, forKey: cacheKey)
                }
            }
        }
        
        task.resume()
    }
    
}
