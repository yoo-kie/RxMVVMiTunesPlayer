//
//  ImageCacheManager.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import UIKit
import RxSwift
import RxCocoa

final class ImageCacheManager {
    
    static let instance = ImageCacheManager()
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    private var imageUrl: String?
    
    func fetchImage(with url: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey: NSString = NSString(string: url)
        
        imageUrl = url
        
        if let image = ImageCacheManager.instance.cache.object(forKey: cacheKey) {
            completion(image)
        }
        
        DispatchQueue.global(qos: .background).async {
            if let imageURL = URL(string: url) {
                let session = URLSession(configuration: .default)
                session.dataTask(with: imageURL) { (data, response, error) in
                    guard error == nil else { return }
                    
                    DispatchQueue.main.async {
                        if let data = data, let image = UIImage(data: data) {
                            if self.imageUrl == url {
                                completion(image)
                            }
                            
                            ImageCacheManager.instance.cache.setObject(image, forKey: cacheKey)
                        }
                    }
                }.resume()
            }
        }
    }
    
}
